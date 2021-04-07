{ lib, buildPythonPackage, fetchPypi, requests, mock, httmock, pythonOlder, pytest, responses }:

buildPythonPackage rec {
  pname = "python-gitlab";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a862c6874524ab585b725a17b2cd2950fc09d6d74205f40a11be2a4e8f2dcaa1";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ mock httmock pytest responses ];

  disabled = pythonOlder "3.6";

  meta = with lib; {
    description = "Interact with GitLab API";
    homepage = "https://github.com/python-gitlab/python-gitlab";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
