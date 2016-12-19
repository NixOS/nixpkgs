{ stdenv, fetchurl, boost, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "xylib-${version}";
  version = "1.4";

  src = fetchurl {
    url = "https://github.com/wojdyr/xylib/releases/download/v${version}/${name}-${version}.tar.bz2";
    sha256 = "09j426qjbg3damch1hfw16j992kn2hj8gs4lpvqgfqdw61kvqivh";
  };

  buildInputs = [ boost zlib bzip2 ];

  meta = with stdenv.lib; {
    description = "Portable library for reading files that contain x-y data from powder diffraction, spectroscopy and other experimental methods";
    license = licenses.lgpl21;
    homepage = http://xylib.sourceforge.net/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
