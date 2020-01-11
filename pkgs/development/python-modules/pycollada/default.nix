{ stdenv, fetchPypi, buildPythonPackage, numpy, dateutil }:

buildPythonPackage rec {
  pname = "pycollada";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b2vz9fp9asw57m3p9zjlz9gddanrhpxbdfimg98ik654kp2vj7r";
  };

  propagatedBuildInputs = [ numpy dateutil ];

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
