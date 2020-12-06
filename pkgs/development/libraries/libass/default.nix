{ stdenv, fetchurl, pkgconfig, yasm
, freetype, fribidi, harfbuzz
, encaSupport ? true, enca ? null # enca support
, fontconfigSupport ? true, fontconfig ? null # fontconfig support
, rasterizerSupport ? false # Internal rasterizer
, largeTilesSupport ? false # Use larger tiles in the rasterizer
, libiconv
}:

assert encaSupport -> enca != null;
assert fontconfigSupport -> fontconfig != null;

let
  mkFlag = optSet: flag: if optSet then "--enable-${flag}" else "--disable-${flag}";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "libass";
  version = "0.15.0";

  src = fetchurl {
    url = "https://github.com/libass/libass/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "0cz8v6kh3f2j5rdjrra2z0h715fa16vjm7kambvqx9hak86262cz";
  };

  configureFlags = [
    (mkFlag encaSupport "enca")
    (mkFlag fontconfigSupport "fontconfig")
    (mkFlag rasterizerSupport "rasterizer")
    (mkFlag largeTilesSupport "large-tiles")
  ];

  nativeBuildInputs = [ pkgconfig yasm ];

  buildInputs = [ freetype fribidi harfbuzz ]
    ++ optional encaSupport enca
    ++ optional fontconfigSupport fontconfig
    ++ optional stdenv.isDarwin libiconv;

  meta = {
    description = "Portable ASS/SSA subtitle renderer";
    homepage    = "https://github.com/libass/libass";
    license     = licenses.isc;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
    repositories.git = "git://github.com/libass/libass.git";
  };
}
