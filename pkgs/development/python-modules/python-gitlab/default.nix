{ stdenv, buildPythonPackage, fetchPypi, requests, six, mock, httmock }:

buildPythonPackage rec {
  pname   = "python-gitlab";
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45125a0ed4d0027d4317bdbd71ca02fc52b0ac160b9d2c3c5be131b4d19f867e";
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
