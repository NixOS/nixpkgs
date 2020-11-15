{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "5.1.2";
  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${version}.tar.gz";
    sha256 = "148j1i0zkwf09qdpk3nc5sssj1dvppw7p0n9rgrg8k56447l1h1b";
  };
  pname = "libosip2";

  meta = {
    license = stdenv.lib.licenses.lgpl21Plus;
    homepage = "https://www.gnu.org/software/osip/";
    description = "The GNU oSIP library, an implementation of the Session Initiation Protocol (SIP)";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = stdenv.lib.platforms.linux;
    inherit version;
  };
}
