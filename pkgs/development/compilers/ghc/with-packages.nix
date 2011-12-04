{stdenv, ghc, packages ? [], makeWrapper}:

stdenv.mkDerivation rec {
  name = "ghc-${ghc.version}-linkdir";

  allPackages = stdenv.lib.closePropagation packages;
  buildInputs = allPackages ++ [makeWrapper];
  propagatedBuildInputs = packages;

  unpackPhase = "true";

  installPhase = ''
    originalTopDir="${ghc}/lib/ghc-${ghc.version}"
    originalPkgDir="$originalTopDir/package.conf.d"
    linkedTopDir="$out/lib"
    linkedPkgDir="$linkedTopDir/package.conf.d"

    ensureDir $out/bin
    ensureDir $linkedTopDir
    ensureDir $linkedPkgDir

    echo "Linking GHC core libraries:"

    if test -f $originalTopDir/settings; then
      echo -n "Linking $originalTopDir/settings "
      ln -s $originalTopDir/settings $linkedTopDir
      echo .
    fi

    echo -n "Linking $originalPkgDir "
    for f in $originalPkgDir/*.conf; do
      ln -s $f $linkedPkgDir
      echo -n .
    done
    echo

    echo "Linking selected packages and dependencies:"

    for currentPath in ${stdenv.lib.concatStringsSep " " allPackages}; do
      currentPkgDir="$currentPath/lib/ghc-pkgs/ghc-${ghc.version}"
      echo -n "Linking $currentPath "
      for f in $currentPath/bin/*; do
        ln -s $f $out/bin
        echo -n .
      done
      for f in $currentPkgDir/*.conf; do
        ln -s $f $linkedPkgDir
        echo -n .
      done
      echo
    done

    echo "Generating package cache ..."
    ${ghc}/bin/ghc-pkg --global-conf $linkedPkgDir recache

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
      test -x ${ghc}/bin/$prg && ln -s ${ghc}/bin/$prg $out/bin/$prg && echo -n .
    done
    echo
  '';

  meta = ghc.meta;
}
