{stdenv, ghc, makeWrapper}:

stdenv.mkDerivation {
  name = "ghc-${ghc.version}-wrapper";

  buildInputs = [makeWrapper];
  propagatedBuildInputs = [ghc];

  unpackPhase = "true";
  installPhase = ''
    ensureDir $out/bin
    cp $GHCGetPackages $out/bin/ghc-get-packages.sh
    chmod 755 $out/bin/ghc-get-packages.sh
    for prg in ghc ghci ghc-${ghc.version} ghci-${ghc.version}; do
      makeWrapper $ghc/bin/$prg $out/bin/$prg --add-flags "\$($out/bin/ghc-get-packages.sh ${ghc.version} \"\$(dirname \$0)\")"
    done
    for prg in runghc runhaskell; do
      makeWrapper $ghc/bin/$prg $out/bin/$prg --add-flags "\$($out/bin/ghc-get-packages.sh ${ghc.version} \"\$(dirname \$0)\" \" -package-conf --ghc-arg=\")"
    done
    for prg in ghc-pkg ghc-pkg-${ghc.version}; do
      makeWrapper $ghc/bin/$prg $out/bin/$prg --add-flags "\$($out/bin/ghc-get-packages.sh ${ghc.version} \"\$(dirname \$0)\" --package-conf=)"
    done
    ensureDir $out/nix-support
    ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
  ''; 
  
  GHCGetPackages = ./ghc-get-packages.sh;

  inherit ghc;
  ghcVersion = ghc.version;
}
