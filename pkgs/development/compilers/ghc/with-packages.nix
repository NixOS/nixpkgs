{stdenv, ghc, packages ? [], makeWrapper}:

stdenv.mkDerivation rec {
  name = "haskell-env-${ghc.name}";

  allPackages = stdenv.lib.closePropagation packages;
  buildInputs = allPackages ++ [makeWrapper];
  propagatedBuildInputs = packages;

  unpackPhase = "true";

  installPhase = ''
    originalTopDir="${ghc}/lib/ghc-${ghc.version}"
    originalPkgDir="$originalTopDir/package.conf.d"
    linkedTopDir="$out/lib"
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
      currentPkgDir="$currentPath/lib/ghc-pkgs/ghc-${ghc.version}"
      # Check if current path is a Cabal package for the current GHC
      if test -d $currentPkgDir; then
        echo -n "Linking $currentPath "
        for f in "$currentPath/bin/"*; do
          ln -s $f $out/bin
          echo -n .
        done
        for f in "$currentPkgDir/"*.conf; do
          ln -s $f $linkedPkgDir
          echo -n .
        done
        echo
      fi
    done

    echo -n "Generating package cache "
    ${ghc}/bin/ghc-pkg --global-conf $linkedPkgDir recache
    echo .

    echo -n "Generating wrappers "

    for prg in ghc ghci ghc-${ghc.version} ghci-${ghc.version}; do
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg --add-flags "-B$linkedTopDir"
      echo -n .
    done

    for prg in runghc runhaskell; do
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg --add-flags "-f $out/bin/ghc"
      echo -n .
    done

    for prg in ghc-pkg ghc-pkg-${ghc.version}; do
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg --add-flags "--global-conf $linkedPkgDir"
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
