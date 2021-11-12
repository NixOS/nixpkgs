{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, websockets
, requests
}:

buildPythonPackage rec {
  pname = "mattermostdriver";
  version = "7.3.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf629c4b8f825bd7196208aa93995ac5077bd60939ba67cca314a7f13c1dbcea";
  };

  propagatedBuildInputs = [ websockets requests ];

  pythonImportsCheck = [ "mattermostdriver" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A Python Mattermost Driver";
    homepage = "https://github.com/Vaelor/python-mattermost-driver";
    license = licenses.mit;
    maintainers = with maintainers; [ globin lheckemann ];
  };
}
