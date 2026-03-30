{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pandas,
  pytestCheckHook,
  scikit-learn,
}:

buildPythonPackage rec {
  pname = "ppscore";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "8080labs";
    repo = "ppscore";
    tag = version;
    hash = "sha256-GhmyVWNWpEMNqXW808UhBHk1r6vOVibxKHVv5wWshLE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pandas
    scikit-learn
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonRelaxDeps = [ "pandas" ];

  pythonImportsCheck = [ "ppscore" ];

  meta = {
    description = "Python implementation of the Predictive Power Score (PPS)";
    homepage = "https://github.com/8080labs/ppscore/";
    changelog = "https://github.com/8080labs/ppscore/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evax ];
  };
}
