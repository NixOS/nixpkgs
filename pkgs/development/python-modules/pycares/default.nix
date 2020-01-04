{ stdenv
, buildPythonPackage
, fetchPypi
, python
, c-ares
, cffi
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "663c000625725d3a63466a674df4ee7f62bf8ca1ae8a0b87a6411eb811e0e794";
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
