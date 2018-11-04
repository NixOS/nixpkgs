{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, pytest
, mock
, betamax
, betamax-matchers
, dateutil
, requests
, pyopenssl
, uritemplate_py
, ndg-httpsclient
, requests_toolbelt
, pyasn1
}:

buildPythonPackage rec {
  pname = "github3.py";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35fea5bf3567a8e88d3660686d83f96ef164e698ce6fb30f9e2b0edded7357af";
  };

  buildInputs = [ unittest2 pytest mock betamax betamax-matchers dateutil ];
  propagatedBuildInputs = [ requests pyopenssl uritemplate_py ndg-httpsclient requests_toolbelt pyasn1 ];

  postPatch = ''
    sed -i -e 's/mock ==1.0.1/mock>=1.0.1/' setup.py
    sed -i -e 's/unittest2 ==0.5.1/unittest2>=0.5.1/' setup.py
  '';

  # TODO: only disable the tests that require network
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://github3py.readthedocs.org/en/master/;
    description = "A wrapper for the GitHub API written in python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
  };

}
