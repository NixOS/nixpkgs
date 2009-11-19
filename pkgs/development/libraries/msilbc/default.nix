{ stdenv, fetchurl, ilbc, mediastreamer, pkgconfig }:

stdenv.mkDerivation rec {
  name = "msilbc-2.0.0";
  
  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/linphone/plugins/sources/${name}.tar.gz";
    sha256 = "0ifydb7qmpync56l4hbrp36n5wrb7gadb76isp643s6wsg7l743j";
  };

  patchPhase = "sed -i /MS_FILTER_SET_FMTP/d ilbc.c";

  propagatedBuildInputs = [ilbc mediastreamer];
  
  buildInputs = [pkgconfig];

  buildPhase = ''
    cc -fPIC -c -pthread -o ilbc.o ilbc.c `pkg-config --cflags mediastreamer`
    echo "next"
    cc `pkg-config --libs mediastreamer` -shared -pthread -o libilbc.so
  '';

  installPhase = ''
    ensureDir $out/lib/mediastreamer/plugins
    cp libilbc.so $out/lib/mediastreamer/plugins
  '';
}
