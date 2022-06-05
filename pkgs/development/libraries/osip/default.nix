{lib, stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "5.3.0";
  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${version}.tar.gz";
    sha256 = "sha256-9HJZFsIs9RSWnvsVw8IHIz1kc5OD99QpVgOLePbK6Mg=";
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
