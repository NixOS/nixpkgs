{ stdenv, haskellCompiler, makeWrapper, coreutils, writeScript }:
let
  hastePlain = haskellCompiler;
in
let
  #
  # wrapper for HASTE, and executables that use it
  #
  # If the wrapper is called when the environment variable NIX_HASTE_HASKELL_ENVIRONMENT
  # is set, then just pass through the call; so it is safe to call the wrapper from
  # an environment build with hasteWithPackages.
  # If NIX_HASTE_HASKELL_ENVIRONMENT is not set, then build a local Haskell environment.
  # For that, collect information about all Haskell packages that are in PATH, and
  # generate a HASTE_PKG database that is passed on with the wrapper.
  # For efficiency reasons, the HASTE_PKG database is saved under /tmp/nix-haskell-env...
  #
  mkHasteWrapper =
    hasteWrapperOut: # output of mkDerivation of wrapper
    target: # content of the file
    output: # the full name of the output file
    extraArg: # extra arguments to add to the target when wrapped
    isExecutable:
      ''
      mkdir -p "$(dirname "${output}")"

      bn="${"\${out##*/}"}"  #get last dir of store path
      hash="${"\${bn%%-*}"}"  #get hash of store path
      CACHEDIR_PREFIX="/tmp/nix-haskell-env-haste-cache-$hash"

      cat >> ${output} <<EOF_NIX_HASKELL_CONFIGURATION
      #! ${stdenv.shell}
      if [ ! -z "\$NIX_HASTE_HASKELL_ENVIRONMENT" ]; then
        exec ${target} "\$@"
      else
        if [ ! -z "\$NIX_HASTE_PKG_DIR_OVERRIDE" ]; then
          CACHEDIR=\$NIX_HASTE_PKG_DIR_OVERRIDE
        else
          CACHEDIR=$CACHEDIR_PREFIX
          for i in \$NIX_PROFILES; do
            PROFILE=\$(${coreutils}/bin/readlink -f \$i)  #get store path of profile
            bn="${"\\\${PROFILE##*/}"}"                   #get last dir of store path
            hash="${"\\\${bn%%-*}"}"                      #get hash of store path
            CACHEDIR="\$CACHEDIR\$hash"
          done
        fi
        if [ ! -d "\$CACHEDIR" ]; then
          ${hastePlain}/bin/haste-pkg init \$CACHEDIR
          ARGS=""
          IFS=":"
          PATH="${hastePlain}/bin:\$PATH"
          for p in \$PATH; do
            PkgDir="\$p/../lib/haste-${hastePlain.version}/packages"
            for i in "\$PkgDir/"*.conf; do
              test -f \$i && ln -sf \$i \$CACHEDIR
            done
          done
          test -f "${hastePlain}/lib/haste-${hastePlain.version}/package" && \\
            ln -sf "${hastePlain}/lib/haste-${hastePlain.version}/packages" \$CACHEDIR/.

          ${hastePlain}/bin/haste-pkg --package-db=\$CACHEDIR recache
        fi
        export NIX_HASTEC=${hasteWrapperOut}/bin/hastec
        export NIX_HASTE_PKG=${hasteWrapperOut}/bin/haste-pkg
        export NIX_HASTE_PACKAGE_PATH=\$CACHEDIR
        exec ${target} ${extraArg} "\$@"
      fi
      EOF_NIX_HASKELL_CONFIGURATION

      ${stdenv.lib.optionalString isExecutable "chmod +x ${output}"}
      '';
in
stdenv.mkDerivation {
  name = "haste-${hastePlain.version}-wrapper";

  buildInputs = [makeWrapper];
  propagatedBuildInputs = [hastePlain];

  unpackPhase = "true";
  installPhase = (''
    runHook preInstall

    ls -l
    echo $out
    mkdir -p $out/bin

    ls -l
    for prg in `ls ${hastePlain}/bin`; do
    '' + (mkHasteWrapper "$out" "${hastePlain}/bin/$prg" "$out/bin/$prg" "" true) + ''
    done

    mkdir -p $out/nix-support
    ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages

    #
    # write a wrapper template that matches the HASTE wrapped here;
    # the primary use is for wrapping executables in cabal.mkDerivation
    # NOTE: maybe allow to add extra arguments within the wrapper as well?
    #
    mkdir -p $out/nix-build-helpers/haskell
    '' + (mkHasteWrapper "$out" "__NIX_HASTE_HASKELL_WRAPPER_TARGET__"
           "$out/nix-build-helpers/haskell/mkHasteWrapperContent.txt" "" false) + ''

    runHook postInstall
  '');

  haste = hastePlain; # keep for now for compatibility reasons; maybe delete later
  inherit hastePlain;
  inherit (hastePlain) meta version;

  # support information for cabal build-support
  compilerName = "haste";
  compilerVersion = hastePlain.version;
  compilerCabalBuildScripts = ../../../build-support/cabal/haste.nix;
}
