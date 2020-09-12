{ stdenv, buildPythonPackage, fetchPypi, requests, mock, httmock, pythonOlder, pytest, responses }:

buildPythonPackage rec {
  pname = "python-gitlab";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e240b5c371d9e98c46c980d878c3f03cd83f3da6cda01d533db27fa3e0dd474f";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ mock httmock pytest responses ];

  disabled = pythonOlder "3.6";

  meta = with stdenv.lib; {
    description = "Interact with GitLab API";
    homepage = "https://github.com/python-gitlab/python-gitlab";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
