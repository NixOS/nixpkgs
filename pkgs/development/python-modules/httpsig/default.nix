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

  patches = [
    # pkg_resources is gone in setuptools 82
    ./no-pkg-resources.patch
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pycryptodome
    requests
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "httpsig" ];

  meta = {
    description = "Sign HTTP requests with secure signatures";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ srhb ];
    homepage = "https://github.com/ahknight/httpsig";
  };
}
