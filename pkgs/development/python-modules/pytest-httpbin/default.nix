{ buildPythonPackage
, lib
, fetchPypi
, pytest
, httpbin
, six
}:

buildPythonPackage rec {
  pname = "pytest-httpbin";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f73320f97d33cc20bc8a08cb945372948de51402559e87e74e92c56b48da0d7";
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
    homepage = "https://github.com/kevin1024/pytest-httpbin";
    license = lib.licenses.mit;
  };
}

