{ stdenv, fetchurl }:

let
  version = "0.8.9.0";
in stdenv.mkDerivation rec {
  pname = "libmodplug";
  inherit version;

  meta = with stdenv.lib; {
    description = "MOD playing library";
    homepage    = "http://modplug-xmms.sourceforge.net/";
    license     = licenses.publicDomain;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ raskin ];
  };

  src = fetchurl {
    url = "mirror://sourceforge/project/modplug-xmms/libmodplug/${version}/${pname}-${version}.tar.gz";
    sha256 = "1pnri98a603xk47smnxr551svbmgbzcw018mq1k6srbrq6kaaz25";
  };
}
