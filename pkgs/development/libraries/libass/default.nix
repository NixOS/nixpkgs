{ stdenv, fetchurl, pkgconfig, yasm
, freetype, fribidi
, encaSupport ? true, enca ? null # enca support
, fontconfigSupport ? true, fontconfig ? null # fontconfig support
, harfbuzzSupport ? true, harfbuzz ? null # harfbuzz support
, rasterizerSupport ? false # Internal rasterizer
, largeTilesSupport ? false # Use larger tiles in the rasterizer
}:

assert encaSupport -> enca != null;
assert fontconfigSupport -> fontconfig != null;
assert harfbuzzSupport -> harfbuzz != null;

let
  mkFlag = optSet: flag: if optSet then "--enable-${flag}" else "--disable-${flag}";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libass-${version}";
  version = "0.12.2";

  src = fetchurl {
    url = "https://github.com/libass/libass/releases/download/${version}/${name}.tar.xz";
    sha256 = "1qzibgqmnnqk2r116lpk1br764g0v74f2zp12y5id0p1plaing37";
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
    ++ optional harfbuzzSupport harfbuzz;

  meta = {
    description = "Portable ASS/SSA subtitle renderer";
    homepage    = https://github.com/libass/libass;
    license     = licenses.isc;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel urkud ];
    repositories.git = git://github.com/libass/libass.git;
  };
}
