{
  buildPythonPackage,
  lib,
  gfortran,
  fetchgit,
  gitUpdater,
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
  version = "1.1.3";

  src = fetchgit {
    url = "https://git.rwth-aachen.de/bannwarthlab/molbar";
    rev = "release_v${version}";
    hash = "sha256-wHvsj1/BJpfbSKEB7Fk8PkH6laN/VMKoluZo+4bprlo=";
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

  passthru.updateScript = gitUpdater {
    rev-prefix = "release_v";
    ignoredVersions = "rc";
  };

  meta = {
    description = "Unique molecular identifiers for molecular barcoding";
    homepage = "https://git.rwth-aachen.de/bannwarthlab/molbar";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sheepforce ];
  };
}
