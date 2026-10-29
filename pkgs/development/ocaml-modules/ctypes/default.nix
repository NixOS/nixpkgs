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

buildDunePackage (finalAttrs: {
  pname = "ctypes";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "ocamllabs";
    repo = "ocaml-ctypes";
    rev = finalAttrs.version;
    hash = "sha256-Wlpk+/MSWmnIRsJfVQMTCYDRixuqLzDpdFNpkQyscA8=";
  };

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [
    integers
    bigarray-compat
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit2 ];

  meta = {
    homepage = "https://github.com/ocamllabs/ocaml-ctypes";
    description = "Library for binding to C libraries using pure OCaml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ericbmerritt ];
  };
})
