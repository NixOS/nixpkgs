{ stdenv, buildDunePackage, fetchFromBitbucket, gnuplot, core }:

buildDunePackage rec {
  pname = "gnuplot";
  version = "0.5.3";

  src = fetchFromBitbucket {
    owner  = "ogu";
    repo   = "${pname}-ocaml";
    rev    = "release-${version}";
    sha256 = "00sn9g46pj8pfh7faiyxg3pfhq7w9knafyabjr464bh6qz5kiin3";
  };

  propagatedBuildInputs = [ core gnuplot ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Ocaml bindings to Gnuplot";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl21;
  };
}
