{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "funcy";
  version = "1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5e399eb739afcb5a3ad38302b7817f6e7fee6f5fc79b213a5d82ea8bce0d9e6";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "http://funcy.readthedocs.org/";
    license = licenses.bsd3;
  };

}
