{ stdenv, automake, autoconf, libtool, zlib, pkg-config, serd }:

stdenv.mkDerivation rec {
  pname = "hdt";
  version = "1.3.3";

  src = fetchGit {
    name = "hdt-${version}";
    url = "https://github.com/rdfhdt/hdt-cpp.git";
    ref = "refs/tags/v${version}";
    rev = "b90d8a3cbb9d976c4a654d25762ee5063ff32a76";
  };

  phases = "unpackPhase patchPhase preConfigurePhases configurePhase buildPhase installPhase";

  buildInputs = [ automake autoconf libtool zlib pkg-config serd ];

  propogatedBuildInputs = [];

  patchPhase = "patchShebangs ./autogen.sh";

  preConfigurePhases = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = "http://www.rdfhdt.org/";
    description = "Header Dictionary Triples (HDT) is a compression format for RDF data that can also be queried for Triple Patterns.";
    license = stdenv.lib.licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.koslambrou ];
  };
}
