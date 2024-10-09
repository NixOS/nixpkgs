{
  stdenv,
  lib,
  fetchzip,
}:

stdenv.mkDerivation {
  name = "TATL*";
  version = "20241001"; # They have no version number so using the time of writing this package as version.
  src = fetchzip {
    url = "https://atila.ibisc.univ-evry.fr/tableau_ATL_star/bin/tatl_star.tar.gz";
    sha256 = "sha256-Yb1zyLqavP44tttLRoULLBVBnUOFM6h2MnrtjEMrH9w=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    install -m755 tatl $out/bin/

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/bin/tatl

    runHook postInstall
  '';

  meta = with lib; {
    description = "The implementation of a tableau-based decision procedure for the full Alternating-time Temporal Logic (ATL*).";
    homepage = "https://atila.ibisc.univ-evry.fr/tableau_ATL_star/";
    license = licenses.unfree; # free download on their website. Given that this is a reasearch tool and not a commercial product the intent clearly is to allow use and they simply did not specify a license.
    maintainers = with maintainers; [ mgttlinger ];
    platforms = [ "x86_64-linux" ];
  };
}
