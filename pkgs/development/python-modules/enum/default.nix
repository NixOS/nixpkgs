{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  pname = "enum";
  version = "0.4.4";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9bdfacf543baf2350df7613eb37f598a802f346985ca0dc1548be6494140fdff";
  };

  doCheck = !isPyPy;

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/enum/;
    description = "Robust enumerated type support in Python";
    license = licenses.gpl2;
  };

}
