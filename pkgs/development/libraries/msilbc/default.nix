{ stdenv, fetchurl, ilbc, mediastreamer, pkgconfig }:

stdenv.mkDerivation rec {
  name = "msilbc-2.1.2";

  src = fetchurl {
    url = "mirror://savannah/linphone/plugins/sources/${name}.tar.gz";
    sha256 = "07j02y994ybh274fp7ydjvi76h34y2c34ndwjpjfcwwr03b48cfp";
  };

  propagatedBuildInputs = [ ilbc mediastreamer ];
  nativeBuildInputs = [ pkgconfig ];

  configureFlags = [
    "ILBC_LIBS=ilbc" "ILBC_CFLAGS=-I${ilbc}/include"
    "MEDIASTREAMER_LIBS=mediastreamer" "MEDIASTREAMER_CFLAGS=-I${mediastreamer}/include"
  ];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
