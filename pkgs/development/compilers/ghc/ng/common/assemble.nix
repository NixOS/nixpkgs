# Assemble a usable compiler out of the packages that make one up.
#
# A GHC installation is not just `bin/ghc`. The driver locates everything else
# relative to its own path -- `$topdir` is `bin/../lib` -- and refuses to start
# without `lib/settings`. So the executables, the settings file and a package
# database have to be brought together into one tree, which is what the dist
# step of stable-haskell's Makefile does and what this derivation does.
#
# Two of these get built: a stage1 compiler with an empty package db, used only
# to compile the boot libraries, and the final compiler that ships them.
{
  lib,
  stdenv,
  runCommand,
  lndir,

  version,

  # `bin/`.
  ghc-bin,
  ghc-pkg,

  # An *assembled* compiler on the build platform, used only to init, recache
  # and check the database. Needed when the `ghc-pkg` we ship is a host binary
  # that cannot run here (`Exec format error`).
  #
  # It has to be a whole compiler tree rather than the bare `ghc-pkg` package:
  # ghc-pkg finds its settings relative to its own executable, so the standalone
  # package fails with `Settings file doesn't exist`.
  #
  # `null` means use the copy in `$out/bin`, which is right whenever it runs
  # here. Same GHC version either way, so the `package.cache` format matches;
  # nothing from here ends up in the output.
  buildGhcPkg ? null,
  unlit,

  # The rest of the programs a GHC installation ships: `hsc2hs`, `hp2ps`,
  # `hpc`, `runghc`. Not optional extras -- GHC's own testsuite refuses to start
  # without hsc2hs, hp2ps and hpc beside `ghc` (`mk/boilerplate.mk`) -- but
  # empty for stage1, which only ever compiles stage2.
  programs ? [ ],

  # The toolchain-derived half of `lib/settings`, from ./settings.nix.
  toolchainSettings,

  # The build-state half, as an attrset. `base unit-id` is deliberately absent:
  # it carries a hash Cabal computes at build time, so it is read out of the
  # registered package.conf below rather than guessed at during evaluation.
  # Reading it at eval time would mean import-from-derivation.
  buildStateSettings,

  jq,

  # Libraries to register, as a list of derivations whose package.conf.d
  # entries are merged into the compiler's global database. Empty for stage1:
  # `cabal.project.stage1` builds executables only, and the Makefile does no
  # more than `ghc-pkg init` an empty directory.
  libraries ? [ ],

  # The GHC source tree, for `driver/ghc-usage.txt` and `ghci-usage.txt`.
  ghcSrc,

  targetPrefix ? "",
}:

let
  # `ghc-pkg` resolves $topdir from its own path, so the external one is used
  # unprefixed: it is a compiler for the build platform in its own right.
  ghcPkgCmd =
    if buildGhcPkg == null then "$out/bin/${targetPrefix}ghc-pkg" else "${buildGhcPkg}/bin/ghc-pkg";
in
runCommand "ghc-${version}"
  {
    inherit version targetPrefix;
    nativeBuildInputs = [ jq ];
    buildStateJson = builtins.toJSON buildStateSettings;

    passthru = {
      inherit
        targetPrefix
        toolchainSettings
        libraries
        ;
      # `generic-builder.nix` and `with-packages-wrapper.nix` read these off a
      # compiler, so anything standing in for one has to provide them.
      isGhcjs = false;
      haskellCompilerName = "ghc-${version}";
      llvmPackages = { };
      enableShared = true;
      hasHaddock = true;
    };

    meta = {
      description = "The Glasgow Haskell Compiler, assembled from its packages";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.all;
    };
  }
  ''
    mkdir -p "$out/bin" "$out/lib"

    # Copied, not symlinked. GHC and ghc-pkg locate `$topdir` from their own
    # executable via /proc/self/exe, which resolves symlinks -- so a symlinked
    # `$out/bin/ghc-pkg` looks for its settings and package database back in
    # the ghc-pkg package, not here:
    #
    #     ghc-pkg: Settings file doesn't exist: .../ghc-pkg-9.14.1/lib/settings
    for exe in ${ghc-bin}/bin/* ${ghc-pkg}/bin/* ${unlit}/bin/* ${
      lib.concatMapStringsSep " " (p: "${p}/bin/*") programs
    }; do
      cp "$exe" "$out/bin/$(basename "$exe")"
    done
    chmod -R u+w "$out/bin"

    # The external interpreter is `Name: iserv` in the .cabal and produces a
    # binary called `iserv`, but GHC looks for `$topdir/../bin/ghc-iserv`:
    #
    #     ghc-iserv: createProcess: posix_spawnp: does not exist
    #
    # hadrian installs it under the `ghc-` name for the same reason. (It also
    # ships `ghc-iserv-prof` and `-dyn`, which need RTS ways we do not build.)
    if [ -e "$out/bin/iserv" ]; then
      cp "$out/bin/iserv" "$out/bin/${targetPrefix}ghc-iserv"
    fi

    # Placeholder; the real settings are written after the package database
    # exists, because `base unit-id` comes out of it.

    # GHC 9.15 reads a typed target description alongside the settings file:
    #
    #   WARNING: target file doesn't exist ".../lib/targets/default.target"
    #   cannot know target platform so guessing target == host (native compiler)
    #
    # This is the mechanism that lets one compiler serve several targets --
    # `lib/targets/<triple>/` in stable-haskell's stage3 -- and it is what
    # cross support will hang off. `ghc-toolchain` already emits it; it just
    # has to be installed.
    mkdir -p "$out/lib/targets"
    cp "${toolchainSettings}/default.target" "$out/lib/targets/default.target"

    # `driver/ghc-usage.txt` is read at `--help` time; GHC warns without it.
    cp ${ghcSrc}/driver/ghc-usage.txt "$out/lib/ghc-usage.txt"
    cp ${ghcSrc}/driver/ghci-usage.txt "$out/lib/ghci-usage.txt"

    # The global package database. `Relative Global Package DB` in settings
    # says where to look, relative to the settings file itself.
    ${ghcPkgCmd} init "$out/lib/package.conf.d"

    ${lib.concatMapStringsSep "\n" (p: ''
      for conf in ${p}/lib/*/package.conf.d/*.conf; do
        [ -e "$conf" ] || continue
        cp "$conf" "$out/lib/package.conf.d/"
      done
    '') libraries}

    # `base unit-id` is a hash Cabal computed when it built `base`, so the only
    # honest source for it is the registered package.conf. hadrian gets it the
    # same way, from `pkgUnitId Stage1 base`. Reading it during evaluation
    # instead would mean import-from-derivation.
    printf '%s' "$buildStateJson" > build-state.json

    # A compiler that ships `base` takes the unit-id from the registered
    # package.conf: it carries a hash Cabal computed at build time, and reading
    # it during evaluation would mean import-from-derivation. hadrian gets it
    # the same way, from `pkgUnitId Stage1 base`.
    #
    # The stage1 compiler ships no libraries at all, so there is nothing to read
    # and whatever `buildStateSettings` said stands. It only ever compiles
    # stage2, which names its packages explicitly.
    baseConf=$(echo "$out/lib/package.conf.d/"base-*.conf)
    if [ -e "$baseConf" ]; then
      baseUnitId=$(sed -n 's/^id: *//p' "$baseConf" | head -1)
      echo "base unit-id: $baseUnitId"
      jq -s --arg baseUnitId "$baseUnitId" \
        '.[0] * .[1] * {"base unit-id": $baseUnitId}' \
        "${toolchainSettings}/settings.json" build-state.json > "$out/lib/settings"
    else
      echo "no base registered; keeping the base unit-id from buildStateSettings"
      jq -s '.[0] * .[1]' \
        "${toolchainSettings}/settings.json" build-state.json > "$out/lib/settings"
    fi

    ${ghcPkgCmd} recache --package-db "$out/lib/package.conf.d"

    echo "--- ghc-pkg check ---"
    ${ghcPkgCmd} check --package-db "$out/lib/package.conf.d"

    ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      echo "--- ghc --version ---"
      "$out/bin/${targetPrefix}ghc" --version
    ''}
  ''
