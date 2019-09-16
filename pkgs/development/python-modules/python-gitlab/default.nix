{ stdenv, buildPythonPackage, fetchPypi, requests, six, mock, httmock }:

buildPythonPackage rec {
  pname   = "python-gitlab";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p0i6gsl4mcv6w1sm0rsxq9bq2cmmg3n7c0dniqlvqmzkk62qqhx";
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
