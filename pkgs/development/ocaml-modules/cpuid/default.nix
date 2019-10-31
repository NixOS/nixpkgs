{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, topkg, ocb-stubblr, buildDunePackage }:

buildDunePackage rec {
  pname = "cpuid";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "pqwy";
    repo = pname;
    rev = "v${version}";
    sha256 = "04zqlvy608kj9pn48q5zybz62rlwzyfmadpwjhcxwcx28km528r4";
  };

  #buildInputs = [ ocb-stubblr ];

  meta = {
    homepage = https://github.com/pqwy/cpuid;
    description = "Detect CPU features from OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
