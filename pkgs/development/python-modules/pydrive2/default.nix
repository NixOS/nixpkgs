{ lib
, buildPythonPackage
, fetchPypi
, google-api-python-client
, oauth2client
, pyopenssl
, pyyaml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pydrive2";
  version = "1.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyDrive2";
    inherit version;
    hash = "sha256-u9yNLgAuT4fSD5vYSfk/1lieu0Da2X+UtvOCtP/Ws8E=";
  };

  propagatedBuildInputs = [
    google-api-python-client
    oauth2client
    pyopenssl
    pyyaml
  ];

  doCheck = false;

  pythonImportsCheck = [
    "pydrive2"
  ];

  meta = with lib; {
    description = "Google Drive API Python wrapper library";
    homepage = "https://github.com/iterative/PyDrive2";
    changelog = "https://github.com/iterative/PyDrive2/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ sei40kr ];
  };
}
