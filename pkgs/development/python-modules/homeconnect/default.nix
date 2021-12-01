{ lib
, buildPythonPackage
, fetchPypi
, requests
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "homeconnect";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n4h4mi23zw3v6fbkz17fa6kkl5v9bfmj0p57jvfzcfww511y9mn";
  };

  propagatedBuildInputs = [
    requests
    requests_oauthlib
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "homeconnect" ];

  meta = with lib; {
    description = "Python client for the BSH Home Connect REST API";
    homepage = "https://github.com/DavidMStraub/homeconnect";
    changelog = "https://github.com/DavidMStraub/homeconnect/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
