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
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TVK/jCqiqCkTDvzKhcFJQ/3QqnVFWquYWyuHJhWcIMo=";
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
