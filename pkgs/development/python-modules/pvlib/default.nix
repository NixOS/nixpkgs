{ stdenv, buildPythonPackage, fetchPypi, numpy, pandas, pytz, six, pytest }:

buildPythonPackage rec {
  pname = "pvlib";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1897v9qq97nk5n0hfm9089yz8pffd42795mnhcyq48g9bsyap1xi";
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
