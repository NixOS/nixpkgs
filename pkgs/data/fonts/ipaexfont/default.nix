{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "ipaexfont";
  version = "004.01";

  src = fetchzip {
    url = "https://moji.or.jp/wp-content/ipafont/IPAexfont/IPAexfont00401.zip";
    hash = "sha256-/87qJIb+v4qrtDy+ApfXxh59reOk+6RhGqFN98mc+8Q=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Japanese font package with Mincho and Gothic fonts";
    longDescription = ''
      IPAex font is a Japanese font developed by the Information-technology
      Promotion Agency of Japan. It provides both Mincho and Gothic fonts,
      suitable for both display and printing.

      This is the successor to the IPA fonts.
    '';
    homepage = "https://moji.or.jp/ipafont/";
    license = licenses.ipa;
    maintainers = with maintainers; [ gebner ];
  };
}
