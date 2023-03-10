{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "freefont-ttf";
  version = "20120503";

  src = fetchzip {
    url = "mirror://gnu/freefont/freefont-ttf-${version}.zip";
    hash = "sha256-K3kVHGcDTxQ7N7XqSdwRObriVkBoBYPKHbyYrYvm7VU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "GNU Free UCS Outline Fonts";
    longDescription = ''
      The GNU Freefont project aims to provide a set of free outline
      (PostScript Type0, TrueType, OpenType...) fonts covering the ISO
      10646/Unicode UCS (Universal Character Set).
    '';
    homepage = "https://www.gnu.org/software/freefont/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
