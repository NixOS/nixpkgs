{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "paratype-pt-serif";
  version = "2.005";

  src = fetchzip {
    urls = [
      "https://company.paratype.com/system/attachments/634/original/ptserif.zip"
      "http://rus.paratype.ru/system/attachments/634/original/ptserif.zip"
    ];
    stripRoot = false;
    hash = "sha256-4L3t5NEHmj975fn8eBAkRUO1OL0xseNp9g7k7tt/O2c=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 *.txt -t $out/share/doc/paratype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.paratype.ru/public/";
    description = "An open Paratype font";

    license = "Open Paratype license";
    # no commercial distribution of the font on its own
    # must rename on modification
    # http://www.paratype.ru/public/pt_openlicense.asp

    platforms = platforms.all;
    maintainers = with maintainers; [ raskin ];
  };
}
