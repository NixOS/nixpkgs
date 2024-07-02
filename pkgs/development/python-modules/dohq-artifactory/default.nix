{
  lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
, python-dateutil
, pyjwt
, nix-update-script
}:

buildPythonPackage rec {
  pname = "dohq-artifactory";
  version = "0.10.0";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YBjIouC9yRK3N5CfHfqI62gUWCLhrWPWutzAkxg6NlM=";
  };

  disabled = pythonOlder "3.8";

  dependencies = [
    requests
    python-dateutil
    pyjwt
  ];

  # includes integration tests, requires live artifactory instance
  doCheck = false;

  pythonImportsCheck = [ "artifactory" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Python interface library for JFrog Artifactory";
    homepage = "https://devopshq.github.io/artifactory/";
    changelog = "https://github.com/devopshq/artifactory/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ h7x4 ];
  };
}
