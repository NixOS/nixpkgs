{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  requests-oauthlib,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "homeconnect";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

<<<<<<< HEAD
  meta = {
    description = "Python client for the BSH Home Connect REST API";
    homepage = "https://github.com/DavidMStraub/homeconnect";
    changelog = "https://github.com/DavidMStraub/homeconnect/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python client for the BSH Home Connect REST API";
    homepage = "https://github.com/DavidMStraub/homeconnect";
    changelog = "https://github.com/DavidMStraub/homeconnect/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
