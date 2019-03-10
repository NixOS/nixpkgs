{ stdenv, buildPythonPackage, fetchPypi, numpy, pandas, pytz, six, pytest }:

buildPythonPackage rec {
  pname = "pvlib";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "56e70747add2e50846dd8bbef9a4735e82c1224ce630d1db7590b96bd59dd3f7";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy pandas pytz six ];

  # Currently, the PyPI tarball doesn't contain the tests. When that has been
  # fixed, enable testing. See: https://github.com/pvlib/pvlib-python/issues/473
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://pvlib-python.readthedocs.io;
    description = "Simulate the performance of photovoltaic energy systems";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
