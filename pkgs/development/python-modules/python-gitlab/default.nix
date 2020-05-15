{ stdenv, buildPythonPackage, fetchPypi, requests, mock, httmock, pythonOlder }:

buildPythonPackage rec {
  pname = "python-gitlab";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c4ea60c8303f4214522b18038df017cae35afda7474efa0b4e19c2e73bc3ae2";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ mock httmock ];

  disabled = pythonOlder "3.6";

  meta = with stdenv.lib; {
    description = "Interact with GitLab API";
    homepage = "https://github.com/python-gitlab/python-gitlab";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
