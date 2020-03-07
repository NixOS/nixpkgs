{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "5.1.1";
  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${version}.tar.gz";
    sha256 = "0kgnxgzf968kbl6rx3hjsfb3jsg4ydgrsf35gzj319i1f8qjifv1";
  };
  pname = "libosip2";

  meta = {
    license = stdenv.lib.licenses.lgpl21Plus;
    homepage = https://www.gnu.org/software/osip/;
    description = "The GNU oSIP library, an implementation of the Session Initiation Protocol (SIP)";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = stdenv.lib.platforms.linux;
    inherit version;
  };
}
