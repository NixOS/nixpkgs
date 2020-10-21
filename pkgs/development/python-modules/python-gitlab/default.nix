{ stdenv, buildPythonPackage, fetchPypi, requests, mock, httmock, pythonOlder, pytest, responses }:

buildPythonPackage rec {
  pname = "python-gitlab";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "68b42aafd4b620ab2534ff78a52584c7f799e4e55d5ac297eab4263066e6f74b";
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
