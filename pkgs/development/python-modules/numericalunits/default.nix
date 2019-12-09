{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  version = "1.24";
  pname = "numericalunits";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wn7kqp0rxqr6gnqhdn8pc0wy359krzan0kbika6hfvb0c1rw1hs";
  };

  disabled = !isPy3k;

  meta = with stdenv.lib; {
    homepage = http://pypi.python.org/pypi/numericalunits;
    description = "A package that lets you define quantities with unit";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
