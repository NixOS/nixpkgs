{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  version = "1.26";
  format = "setuptools";
  pname = "numericalunits";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-igtplF3WXqz27vjIaLzTKY10OfWIL1B7tgYOwgxyPhI=";
  };

  disabled = !isPy3k;

  meta = with lib; {
    homepage = "http://pypi.python.org/pypi/numericalunits";
    description = "Package that lets you define quantities with unit";
    license = licenses.mit;
    maintainers = [ ];
  };
}
