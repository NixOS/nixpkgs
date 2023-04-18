{ lib, buildDunePackage
, opam, unzip
, opam-format, mccs, dose3, cudf, re, opam-0install-cudf
}:

buildDunePackage rec {
  pname = "opam-solver";
  inherit (opam) src version;

  duneVersion = "3";

  nativeBuildInputs = [ unzip ];

  propagatedBuildInputs = [
    opam-format
    mccs
    dose3
    cudf
    re
    opam-0install-cudf
  ];

  # get rid of check for curl at configure time
  configureFlags = [ "--disable-checks" ];

  meta = opam.meta // {
    description = "Solver library for opam";
    maintainers = with lib.maintainers; [ niols ];
  };
}
