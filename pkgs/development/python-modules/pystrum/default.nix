{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  matplotlib,
  numpy,
  scipy,
  six,
}:

buildPythonPackage {
  pname = "pystrum";
  version = "0.4-unstable-2025-01-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adalca";
    repo = "pystrum";
    rev = "d83bd99ce25e3c79789f6891c174c39ec7f5209b";
    hash = "sha256-wzdfxQVSr4A2saSW25wjXzs99I3lTxbxboqrj9A/jJQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    matplotlib
    scipy
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  doCheck = false; # no tests in repo

  pythonImportsCheck = [ "pystrum" ];

  meta = {
    description = "Imaging focused utility library";
    homepage = "https://github.com/adalca/pystrum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
