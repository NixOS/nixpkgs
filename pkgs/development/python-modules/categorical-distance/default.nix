{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unstableGitUpdater,

  # build-system
  setuptools,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "categorical-distance";
  version = "1.9-unstable-2020-03-31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dedupeio";
    repo = "categorical-distance";
    rev = "07d079fd412ccf06cdb200b3cd2cfa4b67f78722";
    hash = "sha256-zSjSrlFiRus/T2XZdakLQpF1u/LV0VNWwrc8lhss6kU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "categorical"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Compare similarity of categorical variables using Jaccard index";
    homepage = "https://github.com/dedupeio/categorical-distance";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
}
