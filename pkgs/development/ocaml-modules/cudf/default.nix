{
  lib,
  buildDunePackage,
  ocaml,
  fetchFromGitLab,
  extlib,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "cudf";
  version = "0.10";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitLab {
    owner = "irill";
    repo = "cudf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E4KXKnso/Q3ZwcYpKPgvswNR9qd/lafKljPMxfStedM=";
  };

  propagatedBuildInputs = [
    extlib
  ];

  checkInputs = [
    ounit2
  ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    description = "Library for CUDF format";
    homepage = "https://www.mancoosi.org/cudf/";
    downloadPage = "https://gforge.inria.fr/projects/cudf/";
    license = lib.licenses.lgpl3;
    maintainers = [ ];
  };
})
