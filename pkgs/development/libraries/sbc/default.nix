{ stdenv, fetchurl, libsndfile, pkgconfig }:

stdenv.mkDerivation rec {
  name = "sbc-1.0";

  src = fetchurl {
    url = "http://www.kernel.org/pub/linux/bluetooth/${name}.tar.xz";
    sha256 = "10mq2rmh3h90bwq5cdcmizf93zf8f2br8gds0jxr9i962ai0m5xz";
  };

  buildInputs = [ pkgconfig libsndfile ];

  meta = {
    description = "SubBand Codec Library";

    homepage = http://www.bluez.org/;

    licenses = stdenv.lib.licenses.gpl2;

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
