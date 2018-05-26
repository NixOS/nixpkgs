{ stdenv, fetchurl, pkgconfig, libebml }:

stdenv.mkDerivation rec {
  name = "libmatroska-1.4.8";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libmatroska/${name}.tar.xz";
    sha256 = "14n9sw974prr3yp4yjb7aadi6x2yz5a0hjw8fs3qigy5shh2piyq";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libebml ];

  meta = with stdenv.lib; {
    description = "A library to parse Matroska files";
    homepage = https://matroska.org/;
    license = licenses.lgpl21;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}

