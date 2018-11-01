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
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cxaqdqmz9w2afc0cw2jyv783fp0grydbik0frzj79azzkhyg4gf";
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
