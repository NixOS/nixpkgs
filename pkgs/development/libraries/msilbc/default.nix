{ stdenv, fetchurl, ilbc, mediastreamer, pkgconfig }:

stdenv.mkDerivation rec {
  name = "msilbc-2.0.3";
  
  src = fetchurl {
    url = "mirror://savannah/linphone/plugins/sources/${name}.tar.gz";
    sha256 = "125yadpc0w1q84839dadin3ahs0gxxfas0zmc4c18mjmf58dmm7d";
  };

#  patchPhase = "sed -i /MS_FILTER_SET_FMTP/d ilbc.c";

  propagatedBuildInputs = [ilbc mediastreamer];

  buildInputs = [pkgconfig];
  configureFlags = "ILBC_LIBS=ilbc ILBC_CFLAGS=-I${ilbc}/include";

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
