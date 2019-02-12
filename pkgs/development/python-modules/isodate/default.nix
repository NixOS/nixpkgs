{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, python
, six
}:

buildPythonPackage rec {
  pname = "isodate";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8";
  };

  propagatedBuildInputs = [ six ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s src/isodate/tests
  '';

  meta = with stdenv.lib; {
    description = "ISO 8601 date/time parser";
    homepage = http://cheeseshop.python.org/pypi/isodate;
    license = licenses.bsd0;
  };

}
