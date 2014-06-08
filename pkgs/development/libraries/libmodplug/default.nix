{ stdenv, fetchurl }:

let
  version = "0.8.8.5";
in stdenv.mkDerivation rec {
  name = "libmodplug-${version}";

  meta = with stdenv.lib; {
    description = "MOD playing library";
    homepage    = "http://modplug-xmms.sourceforge.net/";
    license     = licenses.publicDomain;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ raskin ];
  };

  src = fetchurl {
    url = "mirror://sourceforge/project/modplug-xmms/libmodplug/${version}/${name}.tar.gz";
    sha256 = "1bfsladg7h6vnii47dd66f5vh1ir7qv12mfb8n36qiwrxq92sikp";
  };
}
