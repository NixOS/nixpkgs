{ stdenv, fetchurl, pkgconfig, yasm
, freetype, fribidi
, encaSupport ? true, enca ? null # enca support
, fontconfigSupport ? true, fontconfig ? null # fontconfig support
, harfbuzzSupport ? true, harfbuzz ? null # harfbuzz support
, rasterizerSupport ? false # Internal rasterizer
, largeTilesSupport ? false # Use larger tiles in the rasterizer
, libiconv
}:

assert encaSupport -> enca != null;
assert fontconfigSupport -> fontconfig != null;
assert harfbuzzSupport -> harfbuzz != null;

let
  mkFlag = optSet: flag: if optSet then "--enable-${flag}" else "--disable-${flag}";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "libass";
  version = "0.14.0";

  src = fetchurl {
    url = "https://github.com/libass/libass/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "18iqznl4mabhj9ywfsz4kwvbsplcv1jjxq50nxssvbj8my1267w8";
  };

  configureFlags = [
    (mkFlag encaSupport "enca")
    (mkFlag fontconfigSupport "fontconfig")
    (mkFlag harfbuzzSupport "harfbuzz")
    (mkFlag rasterizerSupport "rasterizer")
    (mkFlag largeTilesSupport "large-tiles")
  ];

  nativeBuildInputs = [ pkgconfig yasm ];

  buildInputs = [ freetype fribidi ]
    ++ optional encaSupport enca
    ++ optional fontconfigSupport fontconfig
    ++ optional harfbuzzSupport harfbuzz
    ++ optional stdenv.isDarwin libiconv;

  meta = {
    description = "Portable ASS/SSA subtitle renderer";
    homepage    = https://github.com/libass/libass;
    license     = licenses.isc;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
    repositories.git = git://github.com/libass/libass.git;
  };
}
