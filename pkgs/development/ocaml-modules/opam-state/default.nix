{ stdenv, fetchFromGitHub, buildDunePackage, opam-repository }:

buildDunePackage rec {
  pname = "opam-state";
  inherit (opam-repository) version src enable_checks;

  propagatedBuildInputs = [
    opam-repository
  ];

  meta = {
    description = "Handling of the ~/.opam hierarchy, repository and switch states.";
    license = stdenv.lib.licenses.lgpl2;
  };
}
