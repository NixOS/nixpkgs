{ stdenv, fetchFromGitHub, pkgconfig, alsaLib, portaudio, portmidi, libsndfile, cmake, libxml2,  ninja }:

stdenv.mkDerivation rec {
  version = "1.0-beta.1";
  name = "JamomaCore-${version}";

  src = fetchFromGitHub {
    owner = "jamoma";
    repo = "JamomaCore";
    rev = "v${version}";
    sha256 = "1hb9b6qc18rsvzvixgllknn756m6zwcn22c79rdibbyz1bhrcnln";
  };

  buildInputs = [ pkgconfig alsaLib portaudio portmidi libsndfile cmake libxml2  ninja ];

  meta = {
    description = "A C++ platform for building dynamic and reflexive systems with an emphasis on audio and media";
    homepage = https://jamoma.org;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
