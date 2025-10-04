{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  joblib,
  llvmlite,
  numba,
  scikit-learn,
  scipy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pynndescent";
  version = "0.5.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lmcinnes";
    repo = "pynndescent";
    tag = "release-${version}";
    hash = "sha256-oE/oy5doHduESHlRPuPHruiw1yUZmuUTe6PrgQlT6O8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    joblib
    llvmlite
    numba
    scikit-learn
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pynndescent" ];

  meta = {
    description = "Nearest Neighbor Descent";
    homepage = "https://github.com/lmcinnes/pynndescent";
    changelog = "https://github.com/lmcinnes/pynndescent/releases/tag/release-${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mic92 ];
    badPlatforms = [
      # The majority of tests are crashing:
      # Fatal Python error: Segmentation fault
      "aarch64-linux"
    ];
  };
}
