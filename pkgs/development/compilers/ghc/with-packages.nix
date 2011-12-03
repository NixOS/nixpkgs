{stdenv, ghcPlain, packages ? [], makeWrapper}:

stdenv.mkDerivation rec {
  name = "ghc-${ghcPlain.version}-linkdir";

  allPackages = stdenv.lib.closePropagation packages;
  buildInputs = allPackages ++ [makeWrapper];
  propagatedBuildInputs = packages;

  unpackPhase = "true";

  installPhase = ''
    originalTopDir="${ghcPlain}/lib/ghc-${ghcPlain.version}"
    originalPkgDir="$originalTopDir/package.conf.d"
    linkedTopDir="$out/lib"
    linkedPkgDir="$linkedTopDir/package.conf.d"

    ensureDir $out/bin
    cd $out/bin

    echo "Generating wrappers ..."

    for prg in ghc ghci ghc-${ghcPlain.version} ghci-${ghcPlain.version}; do
      makeWrapper ${ghcPlain}/bin/$prg $out/bin/$prg --add-flags "-B$linkedTopDir"
    done

    for prg in runghc runhaskell; do
      makeWrapper ${ghcPlain}/bin/$prg $out/bin/$prg --add-flags "-f $out/bin/ghc"
    done

    for prg in ghc-pkg ghc-pkg-${ghcPlain.version}; do
      makeWrapper ${ghcPlain}/bin/$prg $out/bin/$prg --add-flags "--global-conf $linkedPkgDir"
    done

    for prg in hp2ps hpc hasktags hsc2hs haddock haddock-${ghcPlain.version}; do
      test -x ${ghcPlain}/bin/$prg && ln -s ${ghcPlain}/bin/$prg $out/bin/$prg
    done

    ensureDir $linkedTopDir
    cd $linkedTopDir

    if test -f $originalTopDir/settings; then
      echo "Linking $originalTopDir/settings ..."
      ln -s $originalTopDir/settings .
    fi

    ensureDir $linkedPkgDir
    cd $linkedPkgDir

    echo "Linking $originalPkgDir ..."
    ln -s $originalPkgDir/*.conf .

    for currentPath in ${stdenv.lib.concatStringsSep " " allPackages}; do
      currentPkgDir="$currentPath/lib/ghc-pkgs/ghc-${ghcPlain.version}"
      if test -d $currentPkgDir; then
        echo "Linking $currentPkgDir ..."
        ln -s $currentPkgDir/*.conf .
      fi
    done

    echo "Generating package cache ..."
    ${ghcPlain}/bin/ghc-pkg --global-conf $linkedPkgDir recache

  '';

  # inherit ghc.meta;
}
