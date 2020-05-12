{ stdenv, fetchFromGitHub, automake, autoconf, libtool, zlib, pkg-config, serd }:

stdenv.mkDerivation rec {
  pname = "hdt";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "rdfhdt";
    repo = "hdt-cpp";
    rev = "v${version}";
    sha256 = "1vsq80jnix6cy78ayag7v8ajyw7h8dqyad1q6xkf2hzz3skvr34z";
  };

  phases = "unpackPhase patchPhase preConfigurePhases configurePhase buildPhase installPhase";

  buildInputs = [ automake autoconf libtool zlib pkg-config serd ];

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
