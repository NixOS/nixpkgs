{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  requests,
}:

buildPythonPackage rec {
  pname = "oauth2-client";
  version = "1.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U4GQBEj/Gudi63xlxQEALqxGu1yi9JR3/f6vnplp8oQ=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [
    "oauth2_client"
  ];

  meta = {
    description = "Client library for OAuth2";
    homepage = "https://pypi.org/project/oauth2-client/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
