{ stdenv, fetchurl, pkgconfig, yasm
, freetype ? null
, fribidi ? null
, encaSupport ? true, enca ? null # enca support
, fontconfigSupport ? true, fontconfig ? null # fontconfig support
, harfbuzzSupport ? true, harfbuzz ? null # harfbuzz support
, rasterizerSupport ? false # Internal rasterizer
, largeTilesSupport ? false # Use larger tiles in the rasterizer
}:

assert ((freetype != null) && (fribidi != null));
assert encaSupport -> (enca != null);
assert fontconfigSupport -> (fontconfig != null);
assert harfbuzzSupport -> (harfbuzz != null);

let
  mkFlag = optSet: flag: if optSet then "--enable-${flag}" else "--disable-${flag}";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libass-${version}";
  version = "0.12.1";

  src = fetchurl {
    url = "https://github.com/libass/libass/releases/download/${version}/${name}.tar.xz";
    sha256 = "1mwj2nk9g6cq6f8m1hf0ijg1299rghhy9naahqq43sc2whblb1l7";
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
    platforms   = platforms.linux;
    maintainers = with maintainers; [ codyopel urkud ];
    repositories.git = git://github.com/libass/libass.git;
  };
}
