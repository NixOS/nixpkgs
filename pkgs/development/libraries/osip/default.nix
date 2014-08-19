{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "4.0.0";
  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${version}.tar.gz";
    sha256 = "05dhj4s5k4qmhn2amca070xgh1gkcl42n040fhwsn3vm86524bdv";
  };
  name = "libosip2-${version}";

  meta = {
    license = stdenv.lib.licenses.lgpl21Plus;
    homepage = http://www.gnu.org/software/osip/;
    description = "The GNU oSIP library, an implementation of the Session Initiation Protocol (SIP)";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
