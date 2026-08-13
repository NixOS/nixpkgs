{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unstableGitUpdater,

  # build-system
  setuptools,

  # dependencies
  pyhacrf-datamade,
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "highered";
  version = "0.2.1-unstable-2020-03-31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dedupeio";
    repo = "highered";
    rev = "5e6e505e182ff91b1620535a491ad4a3d98ef71e";
    hash = "sha256-sDOAB0QabJ/WJYSIZ31J12kSDQADQUilE2SmGPjXmZo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyhacrf-datamade
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # No tests in repository
  doCheck = false;

  pythonImportsCheck = [
    "highered"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Learnable edit distance using CRF (Conditional Random Fields)";
    homepage = "https://github.com/dedupeio/highered";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
}
