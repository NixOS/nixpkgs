{ stdenv, ghcPlain, makeWrapper, coreutils, writeScript }:

let
  #
  # wrapper for GHC, and executables that use it
  #
  # If the wrapper is called when the environment variable NIX_HASKELL_ENVIRONMENT
  # is set, then just pass through the call; so it is safe to call the wrapper from
  # an environment build with ghcWithPackages.
  # If NIX_HASKELL_ENVIRONMENT is not set, then build a local Haskell environment.
  # For that, collect information about all Haskell packages that are in PATH, and
  # generate a GHC_PKG database that is passed on with the wrapper.
  # For efficiency reasons, the GHC_PKG database is saved under /tmp/nix-haskell-env...
  #
  # TODO: Make script portable to systems that don't have a temporary dir under '/tmp'!
  #
  mkGHCWrapper =
    ghcWrapper:
    target: # content of the file
    output: # the full name of the output file
    extraArg: # extra arguments to add to the target when wrapped
    isExecutable:
      ''
      mkdir -p "$(dirname "${output}")"

      bn="${"\${out##*/}"}"  #get last dir of store path
      hash="${"\${bn%%-*}"}"  #get hash of store path
      CACHEDIR_PREFIX="/tmp/nix-haskell-env-ghc-cache-$hash"

      cat >> ${output} <<EOF_NIX_HASKELL_CONFIGURATION
      #! ${stdenv.shell}
      if [ ! -z "\$NIX_HASKELL_ENVIRONMENT" ]; then
        exec ${target} "\$@"
      else
        CACHEDIR=$CACHEDIR_PREFIX
        for i in \$NIX_PROFILES; do
          PROFILE=\$(${coreutils}/bin/readlink -f \$i)  #get store path of profile
          bn="${"\\\${PROFILE##*/}"}"                   #get last dir of store path
          hash="${"\\\${bn%%-*}"}"                      #get hash of store path
          CACHEDIR="\$CACHEDIR\$hash"
        done
        if [ ! -d "\$CACHEDIR" ]; then
          ${ghcPlain}/bin/ghc-pkg init \$CACHEDIR
          ARGS=""
          IFS=":"
          PATH="${ghcPlain}/bin:\$PATH"
          for p in \$PATH; do
            PkgDir="\$p/../lib/ghc-${ghcPlain.version}/package.conf.d"
            for i in "\$PkgDir/"*.conf; do
              test -f \$i && ln -sf \$i \$CACHEDIR/.
            done
          done
          test -f "${ghcPlain}/lib/ghc-${ghcPlain.version}/package.conf" && \\
            ln -sf "${ghcPlain}/lib/ghc-${ghcPlain.version}/package.conf" \$CACHEDIR/.

          ${ghcPlain}/bin/ghc-pkg --package-db=\$CACHEDIR recache
        fi
        export NIX_GHC=${ghcWrapper}/bin/ghc
        export NIX_GHCPKG=${ghcWrapper}/bin/ghc-pkg
        export NIX_GHC_LIBDIR=${ghcWrapper}/lib/ghc-${ghcPlain.version}
        export NIX_GHC_DOCDIR=${ghcWrapper}/share/doc/ghc/html
        exec ${target} ${extraArg} "\$@"
      fi
      EOF_NIX_HASKELL_CONFIGURATION

      ${stdenv.lib.optionalString isExecutable "chmod +x ${output}"}
      '';

  #
  # function needed in cabal.mkDerivation;
  # will be modified in the future, eventually
  #
  GHCPackages =
    let
      ghc761OrLater = !stdenv.lib.versionOlder ghcPlain.version "7.6.1";
      packageDBFlag = if ghc761OrLater then "-package-db" else "-package-conf";
    in
      writeScript "ghc-packages.sh" ''
        #! ${stdenv.shell} -e
        declare -A GHC_PACKAGES_HASH # using bash4 hashs to get uniq paths
        
        ARGS=""
        IFS=":"
        PATH="${ghcPlain}/bin:$PATH"
        for p in $PATH; do
          PkgDir="$p/../lib/ghc-${ghcPlain.version}/package.conf.d"
          for i in "$PkgDir/"*.installedconf; do
            test -f $i && ARGS="$ARGS ${packageDBFlag} $i"
          done
        done
        test -f "${ghcPlain}/lib/ghc-${ghcPlain.version}/package.conf" && \
          ARGS="$ARGS ${packageDBFlag} ${ghcPlain}/lib/ghc-${ghcPlain.version}/package.conf"
        
        IFS=" "
        for arg in $ARGS; do
          case "$arg" in
            ${packageDBFlag}) ;;
            *)
              CANONICALIZED="$(${coreutils}/bin/readlink -f -- "$arg")"
              GHC_PACKAGES_HASH["$CANONICALIZED"]= ;;
          esac
        done
        
        for path in ''${!GHC_PACKAGES_HASH[@]}; do
          echo -n "$path:"
        done
      '';
in
let
  ghc761OrLater = !stdenv.lib.versionOlder ghcPlain.version "7.6.1";
  globalPackageDBFlag = if ghc761OrLater then "--global-package-db" else "--global-conf";
in
stdenv.mkDerivation {
  name = "ghc-${ghcPlain.version}-wrapper";

  buildInputs = [makeWrapper];
  propagatedBuildInputs = [ghcPlain];

  unpackPhase = "true";
  installPhase = (''
    runHook preInstall

    ls -l
    echo $out
    mkdir -p $out/bin
    ls -l
    for prg in ghc ghci ghc-${ghcPlain.version} ghci-${ghcPlain.version}; do
    '' + (mkGHCWrapper "$out" "${ghcPlain}/bin/$prg" "$out/bin/$prg"
           "-B$out/lib/ghc-${ghcPlain.version}" true) + ''
    done
    for prg in runghc runhaskell; do
    '' + (mkGHCWrapper "$out" "${ghcPlain}/bin/$prg" "$out/bin/$prg" "-f $out/bin/ghc" true) + ''
    done
    for prg in ghc-pkg ghc-pkg-${ghcPlain.version}; do
    '' + (mkGHCWrapper "$out" "${ghcPlain}/bin/$prg" "$out/bin/$prg" "${globalPackageDBFlag}=\\$CACHEDIR" true) + ''
    done
    for prg in hp2ps hpc hasktags hsc2hs; do
      test -x ${ghcPlain}/bin/$prg && ln -s ${ghcPlain}/bin/$prg $out/bin/$prg
    done

    mkdir -p $out/nix-support
    ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages

    mkdir -p $out/share/doc
    ln -s ${ghcPlain}/lib $out/lib
    ln -s ${ghcPlain}/share/doc/ghc $out/share/doc/ghc-${ghcPlain.version}

    #
    # write a wrapper template that matches the GHC wrapped here;
    # the primary use is for wrapping executables in cabal.mkDerivation
    # NOTE: maybe allow to add extra arguments within the wrapper as well?
    #
    mkdir -p $out/nix-build-helpers/haskell
    '' + (mkGHCWrapper "$out" "__NIX_GHC_HASKELL_WRAPPER_TARGET__"
           "$out/nix-build-helpers/haskell/mkGHCWrapperContent.txt" "" false) + ''

    runHook postInstall
  '');

  ghc = ghcPlain; # keep for now for compatibility reasons; maybe delete later
  inherit ghcPlain GHCPackages;
  inherit (ghcPlain) meta version;
}
