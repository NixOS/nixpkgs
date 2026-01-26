{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  requests-oauthlib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "homeconnect";
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W475a+TlGiKRR1EDYiFVmApmQfmft85iBQLRnbEmcuA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    requests-oauthlib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "homeconnect" ];

  meta = {
    description = "Python client for the BSH Home Connect REST API";
    homepage = "https://github.com/DavidMStraub/homeconnect";
    changelog = "https://github.com/DavidMStraub/homeconnect/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
