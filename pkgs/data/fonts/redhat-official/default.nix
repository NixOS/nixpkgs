{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "redhat-official";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "RedHatOfficial";
    repo = "RedHatFont";
    rev = version;
    hash = "sha256-p5RS/57CDApwnRDwMi0gIEJYTDAtibIyyU2w/pnbHJI=";
  };

  installPhase = ''
    runHook preInstall

    for kind in mono proportional; do
      install -m444 -Dt $out/share/fonts/opentype fonts/$kind/static/otf/*.otf
      install -m444 -Dt $out/share/fonts/truetype fonts/$kind/static/ttf/*.ttf
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/RedHatOfficial/RedHatFont";
    description = "Red Hat's Open Source Fonts - Red Hat Display and Red Hat Text";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
