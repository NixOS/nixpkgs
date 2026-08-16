{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "awacs";
  version = "2.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eRmxXir9X08+YEVE+Bxa+OuasPokgcUoc1SJWGeRJ58=";
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
