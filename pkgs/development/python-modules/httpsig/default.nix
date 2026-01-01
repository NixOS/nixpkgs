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

<<<<<<< HEAD
  meta = {
    description = "Sign HTTP requests with secure signatures";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ srhb ];
=======
  meta = with lib; {
    description = "Sign HTTP requests with secure signatures";
    license = licenses.mit;
    maintainers = with maintainers; [ srhb ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/ahknight/httpsig";
  };
}
