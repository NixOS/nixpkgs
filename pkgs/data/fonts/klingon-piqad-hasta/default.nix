{ lib, fetchzip, stdenvNoCC, }:

stdenvNoCC.mkDerivation rec {

  pname = "klingon-piqad-hasta";
  version = "203";

  src = fetchzip {
    url = "https://www.evertype.com/fonts/tlh/${pname}.zip";
    sha256 = "08gc4pinazksyav8h6dxb61g76apdqjfjkhg0gsa4l6az5089b33";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "A standard Klingon typeface, ‘viewscreen writing’ style";
    homepage = "https://www.evertype.com/fonts/tlh/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.chkno ];
  };
}
