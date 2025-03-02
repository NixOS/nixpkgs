{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colorlog";
  version = "6.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v7pUobk7lPVOH0/kg5VyWj2S/SpK9wL2vXCUa9wMasI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "colorlog" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
