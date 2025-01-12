{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "unifont_upper";
  version = "16.0.02";

  src = fetchurl {
    url = "mirror://gnu/unifont/unifont-${version}/${pname}-${version}.otf";
    hash = "sha256-QBc6oiQ6aTiWrqMwyY/YesG+s1JPMggsLT9mZzJsud4=";
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
    license = "https://unifoundry.com/LICENSE.txt";
    maintainers = [ maintainers.mathnerd314 ];
    platforms = platforms.all;
  };
}
