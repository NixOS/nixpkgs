{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "5.1.0";
  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${version}.tar.gz";
    sha256 = "0igic785fh458ck33kxb6i34l7bzdp9zpfjy5dxrcvv5gacklms0";
  };
  name = "libosip2-${version}";

  meta = {
    license = stdenv.lib.licenses.lgpl21Plus;
    homepage = https://www.gnu.org/software/osip/;
    description = "The GNU oSIP library, an implementation of the Session Initiation Protocol (SIP)";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = stdenv.lib.platforms.linux;
    inherit version;
  };
}
