{ buildPythonPackage
, lib
, fetchPypi
, requests
, pytest
, six
, werkzeug
}:

buildPythonPackage rec {
  pname = "pytest-localserver";
  name = "${pname}-${version}";
  version = "0.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c11hn61n06ms0wmw6536vs5k4k9hlndxsb3p170nva56a9dfa6q";
  };

  propagatedBuildInputs = [ werkzeug ];
  buildInputs = [ pytest six requests ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Plugin for the pytest testing framework to test server connections locally";
    homepage = https://pypi.python.org/pypi/pytest-localserver;
    license = lib.licenses.mit;
  };
}

