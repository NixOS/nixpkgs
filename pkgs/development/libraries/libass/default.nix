{ lib, stdenv, fetchurl, pkg-config, yasm
, freetype, fribidi, harfbuzz
, fontconfigSupport ? true, fontconfig ? null # fontconfig support
, rasterizerSupport ? false # Internal rasterizer
, largeTilesSupport ? false # Use larger tiles in the rasterizer
, libiconv
}:

assert fontconfigSupport -> fontconfig != null;

with lib;
stdenv.mkDerivation rec {
  pname = "libass";
  version = "0.15.2";

  src = fetchurl {
    url = "https://github.com/libass/libass/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-G+LfnESFpX14uxjAqO0Ve8h6Wo3UjGYZYcYlyxEoMv0=";
  };

  configureFlags = [
    (enableFeature fontconfigSupport "fontconfig")
    (enableFeature rasterizerSupport "rasterizer")
    (enableFeature largeTilesSupport "large-tiles")
  ];

  nativeBuildInputs = [ pkg-config yasm ];

  buildInputs = [ freetype fribidi harfbuzz ]
    ++ optional fontconfigSupport fontconfig
    ++ optional stdenv.isDarwin libiconv;

  meta = {
    description = "Portable ASS/SSA subtitle renderer";
    homepage    = "https://github.com/libass/libass";
    license     = licenses.isc;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
