{ stdenv, buildPythonPackage, fetchPypi, requests, six, mock, httmock }:

buildPythonPackage rec {
  pname   = "python-gitlab";
  version = "1.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "984e110c1f76fd939652c30ce3101267a7064e34417cbfc4687e6106d4db54ec";
  };

  propagatedBuildInputs = [ requests six ];

  checkInputs = [ mock httmock ];

  meta = with stdenv.lib; {
    description = "Interact with GitLab API";
    homepage    = https://github.com/python-gitlab/python-gitlab;
    license     = licenses.lgpl3;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
