{ stdenv, fetchurl, ilbc, mediastreamer, pkgconfig }:

stdenv.mkDerivation rec {
  name = "msilbc-2.0.3";

  src = fetchurl {
    url = "mirror://savannah/linphone/plugins/sources/${name}.tar.gz";
    sha256 = "125yadpc0w1q84839dadin3ahs0gxxfas0zmc4c18mjmf58dmm7d";
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
