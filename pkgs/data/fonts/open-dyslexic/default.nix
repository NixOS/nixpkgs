{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "open-dyslexic";
  version = "2016-06-23";

  src = fetchzip {
    url = "https://github.com/antijingoist/open-dyslexic/archive/20160623-Stable.zip";
    hash = "sha256-f/uavR3n0qHyqumZDw7r8Zy0om2RlJAKyWuGaUXSJ1s=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 otf/*.otf -t $out/share/fonts/opentype
    install -Dm644 README.md -t $out/share/doc/open-dyslexic

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://opendyslexic.org/";
    description = "Font created to increase readability for readers with dyslexia";
    license = "Bitstream Vera License (https://www.gnome.org/fonts/#Final_Bitstream_Vera_Fonts)";
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
