{ stdenv, fetchurl, pkgconfig, yasm
, freetype, fribidi, fontconfig
, enca ? null
, harfbuzz ? null
}:

let
  version = "0.11.1";
  sha256 = "1b0ki1zdkhflszzj5qr45j9qsd0rfbb6ws5pqkny8jhih0l3lxwx";
  baseurl = "https://github.com/libass/libass/releases/download";
in stdenv.mkDerivation rec {
  name = "libass-${version}";

  src = fetchurl {
    url = "${baseurl}/${version}/${name}.tar.xz";
    inherit sha256;
  };

  nativeBuildInputs = [ pkgconfig yasm ];

  buildInputs = [
    freetype fribidi fontconfig
    enca harfbuzz
  ];

  meta = {
    description = "Portable ASS/SSA subtitle renderer";
    homepage = http://code.google.com/p/libass/;
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    repositories.git = git://github.com/libass/libass.git;
  };
}
