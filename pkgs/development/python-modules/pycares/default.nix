{ stdenv
, buildPythonPackage
, fetchPypi
, python
, c-ares
, cffi
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b253f5dcaa0ac7076b79388a3ac80dd8f3bd979108f813baade40d3a9b8bf0bd";
  };

  buildInputs = [ c-ares ];

  propagatedBuildInputs = [ cffi ];

  checkPhase = ''
    ${python.interpreter} tests/tests.py
  '';

  # requires network access
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/saghul/pycares;
    description = "Interface for c-ares";
    license = licenses.mit;
  };

}
