{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colorlog";
  version = "6.8.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Pj4HmkH+taG2T5eLXqT0YECpTxHw6Lu4Jh49u+ymTUQ=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "colorlog" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
