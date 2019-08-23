{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.23";
  pname = "numericalunits";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q1jrzxx0k7j82c5q061hd10mp965ra8813vb09ji326fbxzn2gy";
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
