{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  _0install-solver,
  alcotest,
  cudf,
}:

buildDunePackage (finalAttrs: {
  pname = "opam-0install-cudf";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ocaml-opam";
    repo = "opam-0install-cudf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TETfvR1Di4c8CylsKnMal/GfQcqMSr36o7511u1bYYs=";
  };

  propagatedBuildInputs = [
    cudf
    _0install-solver
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  meta = {
    homepage = "https://github.com/ocaml-opam/opam-0install-cudf";
    description = "Opam solver using 0install backend using the CUDF interface";
    longDescription = ''
      Opam's default solver is designed to maintain a set of packages
      over time, minimising disruption when installing new programs and
      finding a compromise solution across all packages.

      In many situations (e.g. CI, local roots or duniverse builds) this
      is not necessary, and we can get a solution much faster by using
      a different algorithm.

      This package provides a generic solver library which uses 0install's
      solver library. The library uses the CUDF library in order to interface
      with opam as it is the format common used to talk to all the supported solvers.
    '';
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.stepbrobd ];
  };
})
