{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.16";
  pname = "numericalunits";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71ae8e236c7a223bccefffb670dca68be476dd63b7b9009641fc64099455da25";
  };

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://pypi.python.org/pypi/numericalunits;
    description = "A package that lets you define quantities with unit";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
