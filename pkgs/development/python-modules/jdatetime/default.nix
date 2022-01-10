{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "3.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "389a0723a8011379a5e34386ec466cb3f65b2d5cb5422702c1d3aecb6ac192d0";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Jalali datetime binding for python";
    homepage = "https://pypi.python.org/pypi/jdatetime";
    license = licenses.psfl;
  };
}
