{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libdvdcss-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdcss/${version}/${name}.tar.bz2";
    sha256 = "0nl45ifc4xcb196snv9d6hinfw614cqpzcqp92dg43c0hickg290";
  };

  meta = {
    homepage = http://www.videolan.org/developers/libdvdcss.html;
    description = "A library for decrypting DVDs";
  };
}
