{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cvxpy,
  numpy,
  pandas,
  scipy,
  matplotlib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pepit";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PerformanceEstimation";
    repo = "PEPit";
    tag = version;
    hash = "sha256-6HF/BkDFUvui7CaVfOeJUQhl3QLLyE7aabDWcZ4tgXc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "{{VERSION_PLACEHOLDER}}" "${version}"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    cvxpy
    numpy
    pandas
    scipy
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "PEPit"
  ];

  meta = {
    description = "Performance Estimation in Python";
    changelog = "https://pepit.readthedocs.io/en/latest/whatsnew/${version}.html";
    homepage = "https://pepit.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
