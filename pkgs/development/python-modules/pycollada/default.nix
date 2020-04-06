{ stdenv, fetchPypi, buildPythonPackage, numpy, dateutil }:

buildPythonPackage rec {
  pname = "pycollada";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rp4wlvfywgk3v6l3hnhjx61x9yqawvvivpq4dig2jj71k3mpsyj";
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
