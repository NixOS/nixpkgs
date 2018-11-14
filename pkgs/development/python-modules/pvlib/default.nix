{ stdenv, buildPythonPackage, fetchPypi, numpy, pandas, pytz, six, pytest }:

buildPythonPackage rec {
  pname = "pvlib";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j2p6w41hv7k604jbcpxvs5f04y8dsfdvd3d202l60ks0fc0agyj";
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
