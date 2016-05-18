{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ortp-${version}";
  version = "0.25.0";

  src = fetchurl {
    url = "mirror://savannah/linphone/ortp/sources/${name}.tar.gz";
    sha256 = "16ldzrn1268dr6kdl8mibg2knd6w75a1v0iqfsgk5zdig5mq5sqd";
  };

  meta = with stdenv.lib; {
    description = "A Real-Time Transport Protocol (RFC3550) stack";
    homepage = http://www.linphone.org/index.php/eng/code_review/ortp;
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
