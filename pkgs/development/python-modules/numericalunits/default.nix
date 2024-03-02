{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  version = "1.25";
  format = "setuptools";
  pname = "numericalunits";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c32a482adae818a1a8d6c799bf9fb153326461d490c0de9deab9c694a6537eec";
  };

  disabled = !isPy3k;

  meta = with lib; {
    homepage = "http://pypi.python.org/pypi/numericalunits";
    description = "A package that lets you define quantities with unit";
    license = licenses.mit;
    maintainers = [ ];
  };
}
