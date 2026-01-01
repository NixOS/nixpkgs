{
  lib,
  ocaml,
  fetchFromGitHub,
  buildDunePackage,
  dune-configurator,
  integers,
  bigarray-compat,
  ounit2,
}:

buildDunePackage rec {
  pname = "ctypes";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "ocamllabs";
    repo = "ocaml-ctypes";
    rev = version;
    hash = "sha256-Wlpk+/MSWmnIRsJfVQMTCYDRixuqLzDpdFNpkQyscA8=";
  };

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [
    integers
    bigarray-compat
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit2 ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/ocamllabs/ocaml-ctypes";
    description = "Library for binding to C libraries using pure OCaml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ericbmerritt ];
=======
  meta = with lib; {
    homepage = "https://github.com/ocamllabs/ocaml-ctypes";
    description = "Library for binding to C libraries using pure OCaml";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
