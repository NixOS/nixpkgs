{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "3.5.0";
  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${version}.tar.gz";
    sha256 = "14csf6z7b802bahxd560ibx3mg2fq3ki734vf3k2vknr4jm5v5fx";
  };
  name = "libosip2-${version}";

  meta = {
    license = "LGPLv2.1+";
    homepage = http://www.gnu.org/software/osip/;
    description = "The GNU oSIP library, an implementation of the Session Initiation Protocol (SIP)";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
