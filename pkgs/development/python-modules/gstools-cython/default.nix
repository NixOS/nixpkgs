{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  extension-helpers,
  numpy,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "gstools-cython";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GeoStat-Framework";
    repo = "GSTools-Cython";
    tag = "v${version}";
    hash = "sha256-Kzn/ThLjTGy3ZYIkTwCV1wi22c7rWo4u/L3llppC6wQ=";
  };

  build-system = [
    cython
    extension-helpers
    numpy
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [
    "gstools_cython"
  ];

  meta = {
    description = "Cython backend for GSTools";
    homepage = "https://github.com/GeoStat-Framework/GSTools-Cython";
    changelog = "https://github.com/GeoStat-Framework/GSTools-Cython/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
