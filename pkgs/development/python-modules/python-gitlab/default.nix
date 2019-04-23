{ stdenv, buildPythonPackage, fetchPypi, requests, six, mock, httmock }:

buildPythonPackage rec {
  pname   = "python-gitlab";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rwkl36n1synyggg2li7r075fq5k3cmpgyazinw24bkf7z2kpc56";
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
