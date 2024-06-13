{ lib, buildDunePackage
, opam-0install
, cudf
, ...
}@inputs:

buildDunePackage {
  pname = "opam-0install-cudf";
  inherit (opam-0install) version src;

  duneVersion = "3";

  propagatedBuildInputs = [
    cudf
    inputs."0install-solver"
  ];

  doCheck = true;
  checkInputs = [];

  meta = opam-0install.meta // {
    description = "Opam solver using 0install backend using the CUDF interface";
  };
}
