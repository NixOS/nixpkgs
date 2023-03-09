{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "unifont_upper";
  version = "15.0.01";

  src = fetchurl {
    url = "mirror://gnu/unifont/unifont-${version}/${pname}-${version}.ttf";
    hash = "sha256-o6ItW9fME+f4t2cvhj96r3ZG9nKLAUznn/pdukFYnxw=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/truetype/unifont_upper.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unicode font for glyphs above the Unicode Basic Multilingual Plane";
    homepage = "https://unifoundry.com/unifont/";

    # Basically GPL2+ with font exception.
    license = "https://unifoundry.com/LICENSE.txt";
    maintainers = [ maintainers.mathnerd314 maintainers.vrthra ];
    platforms = platforms.all;
  };
}
