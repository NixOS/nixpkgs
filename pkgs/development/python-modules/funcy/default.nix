{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "funcy";
  version = "1.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65b746fed572b392d886810a98d56939c6e0d545abb750527a717c21ced21008";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "https://funcy.readthedocs.org/";
    license = licenses.bsd3;
  };

}
