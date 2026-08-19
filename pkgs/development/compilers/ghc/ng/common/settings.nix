# GHC's `lib/settings` for one target, produced by `ghc-toolchain`.
#
# This is the piece that makes the whole split worthwhile. In the hadrian-based
# expression, `settings` comes out of autoconf's toolchain probing and is then
# rewritten after the fact by `ghc-settings-edit` in `postInstall`, so the
# compiler derivation is coupled to the C toolchain and every cc change rebuilds
# GHC. Here it is a small, standalone derivation: `ghc-toolchain-bin` probes the
# toolchain and writes the file, and the compiler merely picks it up.
#
# `ghc-toolchain-bin` *runs* the C compiler to probe it, so `cc` must be
# executable on the build platform while targeting the platform the compiler
# will emit code for. That is exactly what a cross `stdenv.cc` is, so the
# ordinary `stdenv` of the set is the right source for these tools -- no
# `targetPackages` reach is needed.
{
  lib,
  stdenv,
  stdenvNoCC,
  runCommand,

  # Build-platform instance. Named by absolute path below, so splicing does not
  # apply: this must be passed explicitly from the build-host package set.
  ghc-toolchain-bin,

  # Only for `config.sub`. `GHC.Toolchain.NormaliseTriple` runs
  # `sh config.sub <triple>` and expects to find the script in the working
  # directory -- in the GHC tree it sits at the top level. Run anywhere else and
  # the call fails silently to the empty string, and the next step rejects the
  # result as a "malformed triple".
  ghcSrc,

  # The triple written into the file and used to name the toolchain. Defaults to
  # the platform this set's libraries are built for, which is what a compiler
  # shipping those libraries targets.
  targetPlatform ? stdenv.hostPlatform,

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
  tripleParts = lib.splitString "-" targetPlatform.config;
  lastPart = lib.last tripleParts;
  ghcTriple =
    if ghcOsAliases ? ${lastPart} then
      lib.concatStringsSep "-" (lib.init tripleParts ++ [ ghcOsAliases.${lastPart} ])
    else
      targetPlatform.config;

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
  ++ lib.optionals (targetPlatform.isElf or false) [
    "--readelf=${bintools}/bin/${prefix}readelf"
  ]
  ++ lib.optionals targetPlatform.isDarwin [
    "--otool=${bintools}/bin/${prefix}otool"
    "--install-name-tool=${bintools}/bin/${prefix}install_name_tool"
  ]
  ++ lib.optionals targetPlatform.isWindows [
    "--windres=${bintools}/bin/${prefix}windres"
  ]
  ++ extraFlags;
in

runCommand "ghc-settings-${targetPlatform.config}"
  {
    # The toolchain goes on PATH as well as being named explicitly: ghc-toolchain
    # probes some tools by name rather than by flag.
    nativeBuildInputs = [
      ghc-toolchain-bin
      cc
      bintools
    ];
    passthru = { inherit flags; };
    meta = {
      description = "GHC toolchain settings for ${targetPlatform.config}";
      platforms = lib.platforms.all;
    };
  }
  ''
    mkdir -p "$out"

    cp "${ghcSrc}/config.sub" .
    chmod +w config.sub

    # Upstream ghc-toolchain emits only the typed `Target`. `--output-settings`,
    # which stable-haskell uses to get a `lib/settings` straight out of this
    # step, is an addition on their fork and does not exist here.
    #
    # That is not merely a missing flag. `lib/settings` is not a function of the
    # toolchain alone -- see `hadrian/src/Rules/Generate.hs:generateSettings`,
    # which fills "RTS ways" from the ways actually built, "base unit-id" from
    # the unit-id of the `base` that was built, and "Relative Global Package DB"
    # from the layout of the tree being assembled. So `settings` belongs to the
    # assembly step, downstream of the boot libraries; this derivation is just
    # the toolchain probe, and it is genuinely standalone.
    ghc-toolchain-bin ${lib.escapeShellArgs flags} --output "$out/default.target"

    # The toolchain-derived subset of `lib/settings`, as JSON. The build-state
    # entries (`base unit-id`, `RTS ways`, `Relative Global Package DB`, ...)
    # are added by the assembly step, which merges this with a Nix-authored
    # object using jq -- inside a derivation, so no import-from-derivation.
    ghc-toolchain-bin ${lib.escapeShellArgs flags} --output-settings-json \
      --output "$out/settings.json"

    echo "--- generated settings.json ---"
    cat "$out/settings.json"
  ''
