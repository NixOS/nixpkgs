{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, betamax
, pytest
, betamax-matchers
, unittest2
, mock
, requests
, uritemplate
, dateutil
, jwcrypto
, pyopenssl
, ndg-httpsclient
, pyasn1
}:

buildPythonPackage rec {
  pname = "github3.py";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15a115c18f7bfcf934dfef7ab103844eb9f620c586bad65967708926da47cbda";
  };

  checkInputs = [ betamax pytest betamax-matchers ]
    ++ lib.optional (pythonOlder "3") unittest2
    ++ lib.optional (pythonOlder "3.3") mock;
  propagatedBuildInputs = [ requests uritemplate dateutil jwcrypto pyopenssl ndg-httpsclient pyasn1 ];

  postPatch = ''
    sed -i -e 's/unittest2 ==0.5.1/unittest2>=0.5.1/' setup.py
  '';

  # TODO: only disable the tests that require network
  doCheck = false;

  meta = with lib; {
    homepage = https://github3py.readthedocs.org/en/master/;
    description = "A wrapper for the GitHub API written in python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
  };

}
