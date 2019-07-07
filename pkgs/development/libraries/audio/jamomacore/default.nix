{ stdenv, fetchFromGitHub, pkgconfig, alsaLib, portaudio, portmidi, libsndfile, cmake, libxml2 }:

stdenv.mkDerivation rec {
  version = "1.0-beta.1";
  name = "JamomaCore-${version}";

  src = fetchFromGitHub {
    owner = "jamoma";
    repo = "JamomaCore";
    rev = "v${version}";
    sha256 = "1hb9b6qc18rsvzvixgllknn756m6zwcn22c79rdibbyz1bhrcnln";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ alsaLib portaudio portmidi libsndfile cmake libxml2 ];

  meta = {
    description = "A C++ platform for building dynamic and reflexive systems with an emphasis on audio and media";
    homepage = http://www.jamoma.org;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
    broken = true; # 2018-04-10
  };
}
