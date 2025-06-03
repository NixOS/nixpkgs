{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mock";
  version = "5.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TkYOgYYptLFz8y0IvzDTr4Ejr7uOBLtXB6H9R5nlA/A=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mock" ];

  meta = with lib; {
    description = "Rolling backport of unittest.mock for all Pythons";
    homepage = "https://github.com/testing-cabal/mock";
    changelog = "https://github.com/testing-cabal/mock/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
