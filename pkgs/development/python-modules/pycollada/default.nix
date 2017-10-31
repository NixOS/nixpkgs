{ stdenv, fetchPypi, buildPythonPackage, numpy, isPy3k, dateutil, dateutil_1_5 }:

buildPythonPackage rec {
  pname = "pycollada";
  version = "0.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1g96maw2c25l4i3ks51784h33zf7s18vrn6iyz4ca34iy4sl7yq9";
  };

  buildInputs = [ numpy ] ++ (if isPy3k then [dateutil] else [dateutil_1_5]);

  # Some tests fail because they refer to test data files that don't exist
  # (upstream packaging issue)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python library for reading and writing collada documents";
    homepage = http://pycollada.github.io/;
    license = "BSD"; # they don't specify which BSD variant
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ bjornfor ];
  };
}
