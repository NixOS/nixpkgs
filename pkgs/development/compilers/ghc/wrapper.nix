{stdenv, ghc, makeWrapper}:

stdenv.mkDerivation {
  name = "ghc-${ghc.version}-wrapper";

  buildInputs = [makeWrapper];
  propagatedBuildInputs = [ghc];

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
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
    for prg in hp2ps hpc hasktags hsc2hs; do
      test -x $ghc/bin/$prg && ln -s $ghc/bin/$prg $out/bin/$prg
    done
    cat >> $out/bin/ghc-packages << EOF
    #! /bin/bash -e
    declare -A GHC_PACKAGES_HASH # using bash4 hashs to get uniq paths

    for arg in \$($out/bin/ghc-get-packages.sh ${ghc.version} \"\$(dirname \$0)\"); do
      case "\$arg" in
        -package-conf) ;;
        *)
          CANONICALIZED="\$(readlink -f "\$arg")"
          GHC_PACKAGES_HASH["\$CANONICALIZED"]= ;;
      esac
    done

    for path in \''${!GHC_PACKAGES_HASH[@]}; do
      echo -n "\$path:"
    done
    EOF
    chmod +x $out/bin/ghc-packages
    mkdir -p $out/nix-support
    ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
  '';

  GHCGetPackages = ./ghc-get-packages.sh;

  inherit ghc;
  inherit (ghc) meta;
  ghcVersion = ghc.version;
}
