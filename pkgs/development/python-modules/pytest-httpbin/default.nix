{ buildPythonPackage
, lib
, fetchPypi
, pytest
, httpbin
, six
}:

buildPythonPackage rec {
  pname = "pytest-httpbin";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wlvw5qgkax7f0i5ks1562s37h2hdmn5yxnp1rajcc2289zm9knq";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ httpbin six ];

  checkPhase = ''
    py.test
  '';

  # https://github.com/kevin1024/pytest-httpbin/pull/51
  doCheck = false;

  meta = {
    description = "Easily test your HTTP library against a local copy of httpbin.org";
    homepage = https://github.com/kevin1024/pytest-httpbin;
    license = lib.licenses.mit;
  };
}

