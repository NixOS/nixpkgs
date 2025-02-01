{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  requests-oauthlib,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "homeconnect";
  version = "0.7.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lkal6Dy4cRRZ893I3/jyQ3+sDZMrHN0UMGff0ab4pvk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    requests
    requests-oauthlib
    six
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
