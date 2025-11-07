{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "unifont_upper";
  version = "16.0.03";

  src = fetchurl {
    url = "mirror://gnu/unifont/unifont-${version}/${pname}-${version}.otf";
    hash = "sha256-ACW+6xiQAd9QMidqJ2MQGTkYbW9fvateIR2FyoM7rIs=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/opentype/unifont_upper.otf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unicode font for glyphs above the Unicode Basic Multilingual Plane";
    homepage = "https://unifoundry.com/unifont/";

    # Basically GPL2+ with font exception.
    license = with lib.licenses; [
      gpl2Plus
      fontException
    ];
    maintainers = [ maintainers.mathnerd314 ];
    platforms = platforms.all;
  };
}
