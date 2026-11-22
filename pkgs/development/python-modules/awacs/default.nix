{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "awacs";
  version = "2.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bM8PMgxHZs8eAjo5cpyxKL1E2ByM1Q7D/tC9QJovkFU=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "awacs" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "AWS Access Policy Language creation library";
    homepage = "https://github.com/cloudtools/awacs";
    changelog = "https://github.com/cloudtools/awacs/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
}
