{ stdenv
, buildPythonPackage
, fetchPypi
, python
, c-ares
, cffi
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18dfd4fd300f570d6c4536c1d987b7b7673b2a9d14346592c5d6ed716df0d104";
  };

  buildInputs = [ c-ares ];

  propagatedBuildInputs = [ cffi ];

  checkPhase = ''
    ${python.interpreter} tests/tests.py
  '';

  # requires network access
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/saghul/pycares";
    description = "Interface for c-ares";
    license = licenses.mit;
  };

}
