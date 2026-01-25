{
  lib,
  buildPythonPackage,
  fetchPypi,
  gssapi,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "requests-gssapi";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uifrMp9IQNllvI+l02DGJ8dDSe+mFWylAa2Jr8ahNPQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gssapi
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "requests_gssapi" ];

  meta = {
    description = "GSSAPI authentication handler for python-requests";
    homepage = "https://github.com/pythongssapi/requests-gssapi";
    changelog = "https://github.com/pythongssapi/requests-gssapi/blob/v${version}/HISTORY.rst";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ javimerino ];
  };
}
