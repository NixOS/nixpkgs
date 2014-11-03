{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "3.6.0";
  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${version}.tar.gz";
    sha256 = "1kcndqvsyxgbhkksgydvvjw15znfq6jiznvw058d21h5fq68p8f9";
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
