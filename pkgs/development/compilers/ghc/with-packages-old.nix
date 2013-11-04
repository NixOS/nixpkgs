{stdenv, ghc, packages ? [], makeWrapper}:

stdenv.mkDerivation rec {
  name = "haskell-env-${ghc.name}";

  allPackages = stdenv.lib.filter (x: x ? pname) (stdenv.lib.closePropagation packages);
  buildInputs = allPackages ++ [makeWrapper];
  propagatedBuildInputs = packages;

  unpackPhase = "true";

  installPhase = ''
    numversion=$(${ghc}/bin/ghc --numeric-version)
    majorversion=''${numversion%%.*}
    minorversion=''${numversion#*.}
    minorversion=''${minorversion%%.*}

    if [[ $majorversion -gt 6 ]] && [[ $minorversion -gt 4 ]]; then
      globalConf="--global-package-db"
    else
      globalConf="--global-conf"
    fi

    originalTopDir="${ghc}/lib/ghc-${ghc.version}"
    originalPkgDir="$originalTopDir/package.conf.d"
    linkedTopDir="$out/lib/ghc-${ghc.version}"
    linkedPkgDir="$linkedTopDir/package.conf.d"

    mkdir -p $out/bin
    mkdir -p $linkedTopDir
    mkdir -p $linkedPkgDir

    echo "Linking GHC core libraries:"

    echo -n "Linking $originalTopDir "
    for f in "$originalTopDir/"*; do
      if test -f $f; then
        ln -s $f $linkedTopDir
        echo -n .
      fi
    done
    echo

    echo -n "Linking $originalPkgDir "
    for f in "$originalPkgDir/"*.conf; do
      ln -s $f $linkedPkgDir
      echo -n .
    done
    echo

    echo "Linking selected packages and dependencies:"

    for currentPath in ${stdenv.lib.concatStringsSep " " allPackages}; do
      currentPkgDir="$currentPath/lib/ghc-${ghc.version}"
      # Check if current path is a Cabal package for the current GHC
      if test -d $currentPkgDir; then
        echo -n "Linking $currentPath "
        for f in "$currentPath/bin/"*; do
          ln -s $f $out/bin
          echo -n .
        done
        for f in "$currentPath/etc/bash_completion.d/"*; do
          mkdir -p $out/etc/bash_completion.d
          ln -s $f $out/etc/bash_completion.d/
          echo -n .
        done
        for s in 1 2 3 4 5 6 7 8 9; do
          for f in "$currentPath/share/man/man$s/"*; do
            mkdir -p $out/share/man/man$s
            ln -sv $f $out/share/man/man$s/
            echo -n .
          done
        done
        for f in "$currentPath/share/emacs/site-lisp/"*; do
          mkdir -p $out/share/emacs/site-lisp
          ln -s $f $out/share/emacs/site-lisp/
          echo -n .
        done
        for f in "$currentPath/share/ghci/"*; do
          mkdir -p $out/share/ghci
          ln -s $f $out/share/ghci/
          echo -n .
        done
        for f in "$currentPkgDir/package.conf.d/"*.conf; do
          ln -s $f $linkedPkgDir
          echo -n .
        done
        echo
      fi
    done

    echo -n "Generating package cache "
    ${ghc}/bin/ghc-pkg $globalConf $linkedPkgDir recache
    echo .

    echo -n "Generating wrappers "

    for prg in ghc ghci ghc-${ghc.version} ghci-${ghc.version}; do
      # The NIX env-vars are picked up by our patched version of ghc-paths.
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg \
        --add-flags "-B$linkedTopDir" \
        --set "NIX_GHC"        "$out/bin/ghc"     \
        --set "NIX_GHCPKG"     "$out/bin/ghc-pkg" \
        --set "NIX_GHC_LIBDIR" "$linkedTopDir"
      echo -n .
    done

    for prg in runghc runhaskell; do
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg --add-flags "-f $out/bin/ghc"
      echo -n .
    done

    for prg in ghc-pkg ghc-pkg-${ghc.version}; do
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg --add-flags "$globalConf $linkedPkgDir"
      echo -n .
    done

    for prg in hp2ps hpc hasktags hsc2hs haddock haddock-${ghc.version}; do
      if test -x ${ghc}/bin/$prg -a ! -x $out/bin/$prg; then
        ln -s ${ghc}/bin/$prg $out/bin/$prg && echo -n .
      fi
    done
    echo
  '';

  meta = ghc.meta;
}
