{ lib
, buildPythonPackage
, fetchPypi
, gssapi
, pytestCheckHook
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "requests-gssapi";
  version = "1.2.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IHhFCJgUAfcVPJM+7QlTOJM6QIGNplolnb8tgNzLFQ4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    gssapi
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportCheck = [
    "requests_gssapi"
  ];

  meta = with lib; {
    description = "A GSSAPI authentication handler for python-requests";
    homepage = "https://github.com/pythongssapi/requests-gssapi";
    changelog = "https://github.com/pythongssapi/requests-gssapi/blob/v${version}/HISTORY.rst";
    license = licenses.isc;
    maintainers = with maintainers; [ javimerino ];
  };
}
