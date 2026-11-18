{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "weather-icons";
  version = "2.0.12";

  src = fetchzip {
    url = "https://github.com/erikflowers/weather-icons/archive/refs/tags/${finalAttrs.version}.zip";
    hash = "sha256-0ZFH2awUo4BkTpK1OsWZ4YKczJHo+HHM6ezGBJAmT+U=";
  };

  nativeBuildInputs = [ installFonts ];

  postPatch = ''
    # Remove duplicate fonts in gh-pages to prevent installFonts hook from tripping
    rm -rf _docs/gh-pages
  '';

  outputs = [
    "out"
    "webfont"
  ];

  meta = {
    description = "Weather Icons";
    longDescription = ''
      Weather Icons is the only icon font and CSS with 222 weather themed icons,
      ready to be dropped right into Bootstrap, or any project that needs high
      quality weather, maritime, and meteorological based icons!
    '';
    homepage = "https://erikflowers.github.io/weather-icons/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pnelson ];
  };
})
