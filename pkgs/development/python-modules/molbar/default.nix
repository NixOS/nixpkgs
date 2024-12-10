{
  buildPythonPackage,
  lib,
  gfortran,
  fetchgit,
  cmake,
  ninja,
  networkx,
  numpy,
  pandas,
  scipy,
  tqdm,
  joblib,
  numba,
  ase,
  scikit-build,
  dscribe,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "MolBar";
  version = "1.1.1";

  src = fetchgit {
    url = "https://git.rwth-aachen.de/bannwarthlab/molbar";
    rev = "release_v${version}";
    hash = "sha256-AFp2x8gil6nbZbgTZmuv+QAMImUMryyCc1by9U/ukYE=";
  };

  pyproject = true;

  nativeBuildInputs = [
    gfortran
  ];

  pythonRelaxDeps = [ "networkx" ];

  build-system = [
    cmake
    scikit-build
    ninja
  ];

  dependencies = [
    networkx
    numpy
    pandas
    scipy
    tqdm
    joblib
    numba
    ase
    dscribe
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  dontUseCmakeConfigure = true;

  doCheck = false; # Doesn't find the fortran libs before installation

  meta = with lib; {
    description = "Unique molecular identifiers for molecular barcoding";
    homepage = "https://git.rwth-aachen.de/bannwarthlab/molbar";
    license = licenses.mit;
    maintainers = [ maintainers.sheepforce ];
  };
}
