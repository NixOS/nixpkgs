{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, websockets
, requests
}:

buildPythonPackage rec {
  pname = "mattermostdriver";
  version = "7.3.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17jqcpa1xd9n7bf4d5l7wmscls34kymv27gi17pyyfjxbwk5gsga";
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
