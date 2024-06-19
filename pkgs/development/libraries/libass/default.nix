{ lib, stdenv, fetchurl, pkg-config, yasm
, freetype, fribidi, harfbuzz
, fontconfigSupport ? true, fontconfig ? null # fontconfig support
, rasterizerSupport ? false # Internal rasterizer
, largeTilesSupport ? false # Use larger tiles in the rasterizer
, libiconv
, darwin
}:

assert fontconfigSupport -> fontconfig != null;

stdenv.mkDerivation rec {
  pname = "libass";
  version = "0.17.1";

  src = fetchurl {
    url = "https://github.com/libass/libass/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-8NoLv7pHbBauPhz9hiJW0wkVkR96uqGxbOYu5lMZJ4Q=";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [
    (lib.enableFeature fontconfigSupport "fontconfig")
    (lib.enableFeature rasterizerSupport "rasterizer")
    (lib.enableFeature largeTilesSupport "large-tiles")
  ];

  nativeBuildInputs = [ pkg-config yasm ];

  buildInputs = [ freetype fribidi harfbuzz ]
    ++ lib.optional fontconfigSupport fontconfig
    ++ lib.optional stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.ApplicationServices
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreText
    ];

  meta = with lib; {
    description = "Portable ASS/SSA subtitle renderer";
    homepage    = "https://github.com/libass/libass";
    license     = licenses.isc;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
