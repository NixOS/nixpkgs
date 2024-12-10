{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  numpy,
  scipy,
  ase,
  joblib,
  sparse,
  pybind11,
  scikit-learn,
}:

buildPythonPackage rec {
  name = "dscribe";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "singroup";
    repo = "dscribe";
    rev = "v${version}";
    fetchSubmodules = true; # Bundles a specific version of Eigen
    hash = "sha256-2JY24cR2ie4+4svVWC4rm3Iy6Wfg0n2vkINz032kPWc=";
  };

  pyproject = true;

  build-system = [
    pybind11
  ];

  dependencies = [
    numpy
    scipy
    ase
    joblib
    sparse
    scikit-learn
  ];

  meta = with lib; {
    description = "Machine learning descriptors for atomistic systems";
    homepage = "https://github.com/SINGROUP/dscribe";
    license = licenses.asl20;
    maintainers = [ maintainers.sheepforce ];
  };
}
