{ stdenv, ghc, makeWrapper, coreutils }:

let
  ghc761OrLater = !stdenv.lib.versionOlder ghc.version "7.6.1";
  packageDBFlag = if ghc761OrLater then "-package-db" else "-package-conf";
in
stdenv.mkDerivation ({
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
      makeWrapper $ghc/bin/$prg $out/bin/$prg --add-flags "\$($out/bin/ghc-get-packages.sh ${ghc.version} \"\$(dirname \$0)\" \" ${packageDBFlag} --ghc-arg=\")"
    done
    for prg in ghc-pkg ghc-pkg-${ghc.version}; do
      makeWrapper $ghc/bin/$prg $out/bin/$prg --add-flags "\$($out/bin/ghc-get-packages.sh ${ghc.version} \"\$(dirname \$0)\" -${packageDBFlag}=)"
    done
    for prg in hp2ps hpc hasktags hsc2hs; do
      test -x $ghc/bin/$prg && ln -s $ghc/bin/$prg $out/bin/$prg
    done
    cat >> $out/bin/ghc-packages << EOF
    #! /bin/bash -e
    declare -A GHC_PACKAGES_HASH # using bash4 hashs to get uniq paths

    for arg in \$($out/bin/ghc-get-packages.sh ${ghc.version} \"\$(dirname \$0)\"); do
      case "\$arg" in
        ${packageDBFlag}) ;;
        *)
          CANONICALIZED="\$(${stdenv.lib.optionalString stdenv.isDarwin "${coreutils}/bin/"}readlink -f "\$arg")"
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
} // (stdenv.lib.optionalAttrs ghc761OrLater { preFixup = "sed -i -e 's|-package-conf|${packageDBFlag}|' $out/bin/ghc-get-packages.sh"; }))
