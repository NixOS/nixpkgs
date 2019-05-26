{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "funcy";
  version = "1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vdbh0ykmjsvq4vb3hrx5327q9ccl1jhbjca59lsr0v0ghwb0grz";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "https://funcy.readthedocs.org/";
    license = licenses.bsd3;
  };

}
