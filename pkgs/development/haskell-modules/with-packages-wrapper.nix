{ lib, stdenv, haskellPackages, symlinkJoin, makeWrapper
# GHC will have LLVM available if necessary for the respective target,
# so useLLVM only needs to be changed if -fllvm is to be used for a
# platform that has NCG support
, useLLVM ? false
, withHoogle ? false
# Whether to install `doc` outputs for GHC and all included libraries.
, installDocumentation ? true
, hoogleWithPackages
, postBuild ? ""
, ghcLibdir ? null # only used by ghcjs, when resolving plugins
}:

# This argument is a function which selects a list of Haskell packages from any
# passed Haskell package set.
#
# Example:
#   (hpkgs: [ hpkgs.mtl hpkgs.lens ])
selectPackages:

# It's probably a good idea to include the library "ghc-paths" in the
# compiler environment, because we have a specially patched version of
# that package in Nix that honors these environment variables
#
#   NIX_GHC
#   NIX_GHCPKG
#   NIX_GHC_DOCDIR
#   NIX_GHC_LIBDIR
#
# instead of hard-coding the paths. The wrapper sets these variables
# appropriately to configure ghc-paths to point back to the wrapper
# instead of to the pristine GHC package, which doesn't know any of the
# additional libraries.
#
# A good way to import the environment set by the wrapper below into
# your shell is to add the following snippet to your ~/.bashrc:
#
#   if [ -e ~/.nix-profile/bin/ghc ]; then
#     eval $(grep export ~/.nix-profile/bin/ghc)
#   fi

let
  inherit (haskellPackages) llvmPackages ghc;

  packages      = selectPackages haskellPackages
                  ++ lib.optional withHoogle (hoogleWithPackages selectPackages);

  isGhcjs       = ghc.isGhcjs or false;
  isHaLVM       = ghc.isHaLVM or false;
  ghc761OrLater = isGhcjs || isHaLVM || lib.versionOlder "7.6.1" ghc.version;
  packageDBFlag = if ghc761OrLater then "--global-package-db" else "--global-conf";
  ghcCommand'   = if isGhcjs then "ghcjs" else "ghc";
  ghcCommand    = "${ghc.targetPrefix}${ghcCommand'}";
  ghcCommandCaps= lib.toUpper ghcCommand';
  libDir        = if isHaLVM then "$out/lib/HaLVM-${ghc.version}"
                  else "$out/lib/${ghc.targetPrefix}${ghc.haskellCompilerName}"
                    + lib.optionalString (ghc ? hadrian) "/lib";
  # Boot libraries for GHC are present in a separate directory.
  bootLibDir    = let arch = if stdenv.targetPlatform.isAarch64
                             then "aarch64"
                             else "x86_64";
                      platform = if stdenv.targetPlatform.isDarwin then "osx" else "linux";
                  in "${ghc}/lib/${ghc.haskellCompilerName}/lib/${arch}-${platform}-${ghc.haskellCompilerName}";
  docDir        = "$out/share/doc/ghc/html";
  packageCfgDir = "${libDir}/package.conf.d";
  paths         = lib.concatLists (
                    builtins.map
                      (pkg: [ pkg ] ++ lib.optionals installDocumentation [ (lib.getOutput "doc" pkg) ])
                      (lib.filter (x: x ? isHaskellLibrary) (lib.closePropagation packages))
                  );
  hasLibraries  = lib.any (x: x.isHaskellLibrary) paths;
  # CLang is needed on Darwin for -fllvm to work:
  # https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/codegens.html#llvm-code-generator-fllvm
  llvm          = lib.makeBinPath
                  ([ llvmPackages.llvm ]
                   ++ lib.optional stdenv.targetPlatform.isDarwin llvmPackages.clang);
in

assert ghcLibdir != null -> (ghc.isGhcjs or false);

if paths == [] && !useLLVM then ghc else
symlinkJoin {
  # this makes computing paths from the name attribute impossible;
  # if such a feature is needed, the real compiler name should be saved
  # as a dedicated drv attribute, like `compiler-name`
  name = ghc.name + "-with-packages";
  paths = paths
          ++ [ ghc ]
          ++ lib.optionals installDocumentation [ (lib.getOutput "doc" ghc) ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    # wrap compiler executables with correct env variables

    for prg in ${ghcCommand} ${ghcCommand}i ${ghcCommand}-${ghc.version} ${ghcCommand}i-${ghc.version}; do
      if [[ -x "${ghc}/bin/$prg" ]]; then
        rm -f $out/bin/$prg
        makeWrapper ${ghc}/bin/$prg $out/bin/$prg                           \
          --add-flags '"-B$NIX_${ghcCommandCaps}_LIBDIR"'                   \
          --set "NIX_${ghcCommandCaps}"        "$out/bin/${ghcCommand}"     \
          --set "NIX_${ghcCommandCaps}PKG"     "$out/bin/${ghcCommand}-pkg" \
          --set "NIX_${ghcCommandCaps}_DOCDIR" "${docDir}"                  \
          --set "NIX_${ghcCommandCaps}_LIBDIR" "${libDir}"                  \
          ${lib.optionalString (ghc.isGhcjs or false)
            ''--set NODE_PATH "${ghc.socket-io}/lib/node_modules"''
          } \
          ${lib.optionalString useLLVM ''--prefix "PATH" ":" "${llvm}"''}
      fi
    done

    for prg in runghc runhaskell; do
      if [[ -x "${ghc}/bin/$prg" ]]; then
        rm -f $out/bin/$prg
        makeWrapper ${ghc}/bin/$prg $out/bin/$prg                           \
          --add-flags "-f $out/bin/${ghcCommand}"                           \
          --set "NIX_${ghcCommandCaps}"        "$out/bin/${ghcCommand}"     \
          --set "NIX_${ghcCommandCaps}PKG"     "$out/bin/${ghcCommand}-pkg" \
          --set "NIX_${ghcCommandCaps}_DOCDIR" "${docDir}"                  \
          --set "NIX_${ghcCommandCaps}_LIBDIR" "${libDir}"
      fi
    done

    for prg in ${ghcCommand}-pkg ${ghcCommand}-pkg-${ghc.version}; do
      if [[ -x "${ghc}/bin/$prg" ]]; then
        rm -f $out/bin/$prg
        makeWrapper ${ghc}/bin/$prg $out/bin/$prg --add-flags "${packageDBFlag}=${packageCfgDir}"
      fi
    done

    # haddock was referring to the base ghc, https://github.com/NixOS/nixpkgs/issues/36976
    if [[ -x "${ghc}/bin/haddock" ]]; then
      rm -f $out/bin/haddock
      makeWrapper ${ghc}/bin/haddock $out/bin/haddock    \
        --add-flags '"-B$NIX_${ghcCommandCaps}_LIBDIR"'  \
        --set "NIX_${ghcCommandCaps}_LIBDIR" "${libDir}"
    fi

  '' + (lib.optionalString (stdenv.targetPlatform.isDarwin && !isGhcjs && !stdenv.targetPlatform.isiOS) ''
    # Work around a linker limit in macOS Sierra (see generic-builder.nix):
    local packageConfDir="${packageCfgDir}";
    local dynamicLinksDir="$out/lib/links";
    mkdir -p $dynamicLinksDir
    # Clean up the old links that may have been (transitively) included by
    # symlinkJoin:
    rm -f $dynamicLinksDir/*

    # Boot libraries are located differently than other libraries since GHC 9.6, so handle them separately.
    if [[ -x "${bootLibDir}" ]]; then
      ln -s "${bootLibDir}"/*.dylib $dynamicLinksDir
    fi

    for d in $(grep -Poz "dynamic-library-dirs:\s*\K .+\n" $packageConfDir/*|awk '{print $2}'|sort -u); do
      ln -s $d/*.dylib $dynamicLinksDir
    done
    for f in $packageConfDir/*.conf; do
      # Initially, $f is a symlink to a read-only file in one of the inputs
      # (as a result of this symlinkJoin derivation).
      # Replace it with a copy whose dynamic-library-dirs points to
      # $dynamicLinksDir
      cp $f $f-tmp
      rm $f
      sed "N;s,dynamic-library-dirs:\s*.*\n,dynamic-library-dirs: $dynamicLinksDir\n," $f-tmp > $f
      rm $f-tmp
    done
  '') + ''
    ${lib.optionalString hasLibraries ''
     # GHC 8.10 changes.
     # Instead of replacing package.cache[.lock] with the new file,
     # ghc-pkg is now trying to open the file.  These file are symlink
     # to another nix derivation, so they are not writable.  Removing
     # them allow the correct behavior of ghc-pkg recache
     # See: https://github.com/NixOS/nixpkgs/issues/79441
     rm ${packageCfgDir}/package.cache.lock
     rm ${packageCfgDir}/package.cache

     $out/bin/${ghcCommand}-pkg recache
     ''}
    ${# ghcjs will read the ghc_libdir file when resolving plugins.
      lib.optionalString (isGhcjs && ghcLibdir != null) ''
      mkdir -p "${libDir}"
      rm -f "${libDir}/ghc_libdir"
      printf '%s' '${ghcLibdir}' > "${libDir}/ghc_libdir"
    ''}
    $out/bin/${ghcCommand}-pkg check
  '' + postBuild;
  preferLocalBuild = true;
  passthru = {
    inherit (ghc) version meta;

    # Inform users about backwards incompatibilities with <= 21.05
    override = _: throw ''
      The ghc.withPackages wrapper itself can now be overridden, but no longer
      the result of calling it (as before). Consequently overrides need to be
      adjusted: Instead of

        (ghc.withPackages (p: [ p.my-package ])).override { withLLLVM = true; }

      use

        (ghc.withPackages.override { useLLVM = true; }) (p: [ p.my-package ])

      Also note that withLLVM has been renamed to useLLVM for consistency with
      the GHC Nix expressions.'';
  };
}
