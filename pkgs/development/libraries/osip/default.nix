{lib, stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "5.2.0";
  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${version}.tar.gz";
    sha256 = "0xdk3cszkzb8nb757gl47slrr13mf6xz43ab4k343fv8llp8pd2g";
  };
  pname = "libosip2";

  meta = {
    license = lib.licenses.lgpl21Plus;
    homepage = "https://www.gnu.org/software/osip/";
    description = "The GNU oSIP library, an implementation of the Session Initiation Protocol (SIP)";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.all;
  };
}
