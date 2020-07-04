{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "dtopt";
  version = "0.1";
  # Test contain Python 2 print
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "06ae07a12294a7ba708abaa63f838017d1a2faf6147a1e7a14ca4fa28f86da7f";
  };

  meta = with stdenv.lib; {
    description = "Add options to doctest examples while they are running";
    homepage = "https://pypi.python.org/pypi/dtopt";
    license = licenses.mit;
  };

}
