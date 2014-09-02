{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  version = "4.1.0";
  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${version}.tar.gz";
    sha256 = "014503kqv7z63az6lgxr5fbajlrqylm5c4kgbf8p3a0n6cva0slr";
  };
  name = "libosip2-${version}";

  meta = {
    license = stdenv.lib.licenses.lgpl21Plus;
    homepage = http://www.gnu.org/software/osip/;
    description = "The GNU oSIP library, an implementation of the Session Initiation Protocol (SIP)";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = stdenv.lib.platforms.linux;
    inherit version;
  };
}
