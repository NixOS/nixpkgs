{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pycryptodome,
  requests,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "httpsig";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cdbVAkYSnE98/sIPXlfjUdK4SS1jHMKqlnkUrPkfbOY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pycryptodome
    requests
    six
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "httpsig" ];

  meta = with lib; {
    description = "Sign HTTP requests with secure signatures";
    license = licenses.mit;
    maintainers = with maintainers; [ srhb ];
    homepage = "https://github.com/ahknight/httpsig";
  };
}
