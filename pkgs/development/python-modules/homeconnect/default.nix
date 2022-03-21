{ lib
, buildPythonPackage
, fetchPypi
, requests
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "homeconnect";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/h0dEVmP0R9tVt56mvu72Ksrvnuox1FA7BgrZMOhV6Q=";
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
