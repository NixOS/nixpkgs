{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "funcy";
  version = "1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i55c5kjvkb3y2jqfnlx3iirrd512mxjdhjpm1l2xya6nk1q9vkm";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "https://funcy.readthedocs.org/";
    license = licenses.bsd3;
  };

}
