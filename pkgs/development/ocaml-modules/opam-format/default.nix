{ stdenv, fetchFromGitHub, buildDunePackage, opam-core }:

buildDunePackage rec {
  pname = "opam-format";
  inherit (opam-core) version src enable_checks;

  propagatedBuildInputs = [
    opam-core
  ];

  meta = {
    description = "Definition of opam datastructures and its file interface.";
    license = stdenv.lib.licenses.lgpl2;
  };
}
