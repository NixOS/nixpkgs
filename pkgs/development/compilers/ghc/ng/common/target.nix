# GHC's `lib/targets/default.target` for one target, produced by
# `ghc-toolchain`.
#
# This is the piece that makes the whole split worthwhile. In the hadrian-based
# expression the toolchain description comes out of autoconf's probing and is
# then rewritten after the fact by `ghc-settings-edit` in `postInstall`, so the
# compiler derivation is coupled to the C toolchain and every cc change rebuilds
# GHC. Here it is a small, standalone derivation: `ghc-toolchain-bin` probes the
# toolchain and writes the file, and the compiler merely picks it up.
#
# `ghc-toolchain-bin` *runs* the C compiler to probe it, so `cc` must be
# executable on the build platform while targeting the platform the compiler
# will emit code for. That is exactly what a cross `stdenv.cc` is, so the
# ordinary `stdenv` of the set is the right source for these tools -- no
# `targetPackages` reach is needed.
#
# Which is why the platform described here is `stdenv.hostPlatform`, and
# deliberately not nixpkgs' `stdenv.targetPlatform`: this package set is indexed
# by the platform its libraries are built for, so a compiler shipping those
# libraries emits code for exactly the set's *host*. GHC's target is our host --
# the `_wrappers` off-by-one of ../README.md, seen from the other end.
{
  lib,
  stdenv,

  # Build-platform instance. Named by absolute path below, so splicing does not
  # apply: this must be passed explicitly from the build-host package set.
  ghc-toolchain-bin,

  # `GHC.Toolchain.NormaliseTriple` runs `sh config.sub <triple>` and expects to
  # find the script in the working directory -- in the GHC tree it sits at the
  # top level. Run anywhere else and the call fails silently to the empty
  # string, and the next step rejects the result as a "malformed triple".
  #
  # nixpkgs' own copy rather than the one vendored in the GHC tree: it is the
  # same script, kept current by `gnu-config`, and taking it from there is what
  # leaves this derivation independent of the GHC sources entirely.
  gnu-config,

  # Extra `ghc-toolchain` flags for targets that need them (wasm wants
  # `--merge-objs`, ghcjs `--disable-tables-next-to-code`, and so on).
  extraFlags ? [ ],

  # GHC-style LLVM triple, if the target needs the LLVM backend. See below.
  llvmTriple ? null,
}:

let
  # GHC's triple parser knows a fixed set of OS names, and nixpkgs does not
  # always spell them the same way:
  #
  #     Unknown operating system wasip1
  #
  # nixpkgs says `wasm32-unknown-wasip1` (naming the WASI preview), while GHC
  # -- like `config.sub` -- knows only `wasi`. The version is not something GHC
  # models, so collapsing it loses nothing.
  #
  # Only the OS field is rewritten, and only where the two disagree; everything
  # else passes through as nixpkgs spells it.
  ghcOsAliases = {
    wasip1 = "wasi";
    wasip2 = "wasi";
  };
  tripleParts = lib.splitString "-" stdenv.hostPlatform.config;
  lastPart = lib.last tripleParts;
  ghcTriple =
    if ghcOsAliases ? ${lastPart} then
      lib.concatStringsSep "-" (lib.init tripleParts ++ [ ghcOsAliases.${lastPart} ])
    else
      stdenv.hostPlatform.config;

  cc = stdenv.cc;
  # The *wrapped* bintools, not `cc.bintools.bintools`. nixpkgs GHC records the
  # wrapper in `settings` (`binutils-wrapper-2.46/bin/ar`), and it must: the
  # wrapper is what applies the store-path-aware flags. Naming the unwrapped
  # tools here silently drops all of that.
  bintools = cc.bintools;
  prefix = stdenv.cc.targetPrefix;

  # `--disable-ld-override` keeps GHC from second-guessing the linker the cc
  # wrapper already selected. stable-haskell passes it unconditionally for the
  # same reason, and in nixpkgs it matters more: the wrapper is the whole point.
  flags = [
    "--triple=${ghcTriple}"
    "--disable-ld-override"
    "--cc=${cc}/bin/${prefix}cc"
    "--cxx=${cc}/bin/${prefix}c++"
    "--cpp=${cc}/bin/${prefix}cc"
    "--cmm-cpp=${cc}/bin/${prefix}cc"
    "--cc-link=${cc}/bin/${prefix}cc"
    "--ar=${bintools}/bin/${prefix}ar"
    "--ranlib=${bintools}/bin/${prefix}ranlib"
    "--nm=${bintools}/bin/${prefix}nm"
    "--ld=${bintools}/bin/${prefix}ld"
    # Without this, ghc-toolchain falls back to searching PATH for `ld` and
    # fails with "Neither a object-merging tool (e.g. ld -r) nor an ar that
    # supports -L is available" -- nixpkgs binutils `ar` does not support `-L`,
    # so the merge-objs path is the only one left. Targets that need something
    # else (wasm wants `wasm-ld -r`) override via `extraFlags`.
    "--merge-objs=${bintools}/bin/${prefix}ld"
  ]
  ++ lib.optionals (llvmTriple != null) [
    # GHC spells LLVM triples its own way -- `x86_64-unknown-linux`, not the
    # autoconf `x86_64-unknown-linux-gnu` that the probe otherwise echoes back
    # from `--triple`. Only the LLVM backend consults it, so it is left unset
    # until a target actually needs it rather than guessed at here.
    "--llvm-triple=${llvmTriple}"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isElf or false) [
    "--readelf=${bintools}/bin/${prefix}readelf"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--otool=${bintools}/bin/${prefix}otool"
    "--install-name-tool=${bintools}/bin/${prefix}install_name_tool"
  ]
  ++ lib.optionals stdenv.hostPlatform.isWindows [
    "--windres=${bintools}/bin/${prefix}windres"
  ]
  ++ extraFlags;
in

stdenv.mkDerivation {
  name = "ghc-target";

  # `stdenv.mkDerivation` rather than `runCommand`, which is `stdenvNoCC`: this
  # derivation *runs* the C toolchain in order to probe it, so it should get one
  # the way any other derivation does. That is also why `cc` and `bintools` are
  # not named here -- listing them would be re-deriving what the stdenv already
  # puts on PATH. `ghc-toolchain` probes some tools by name rather than by flag,
  # so PATH matters as well as the absolute paths in `flags`.
  nativeBuildInputs = [ ghc-toolchain-bin ];

  passthru = { inherit flags; };

  meta = {
    description = "GHC toolchain description for ${stdenv.hostPlatform.config}";
    platforms = lib.platforms.all;
  };

  buildCommand = ''
    mkdir -p "$out"

    cp "${gnu-config}/config.sub" .
    chmod +w config.sub
  ''
  # Upstream ghc-toolchain emits only the typed `Target`. `--output-settings`,
  # which stable-haskell uses to get a `lib/settings` straight out of this
  # step, is an addition on their fork and does not exist here.
  #
  # Nothing is missing as a result. Now that the toolchain facts live in the
  # target file, what is left of `lib/settings.json` is build state -- which
  # RTS ways were built, the unit-id `base` ended up with, where the package
  # database sits -- and that belongs to the assembly step, downstream of the
  # boot libraries. This derivation is just the toolchain probe, and it is
  # genuinely standalone.
  + ''
    ghc-toolchain-bin ${lib.escapeShellArgs flags} --output "$out/default.target"
  '';
}
