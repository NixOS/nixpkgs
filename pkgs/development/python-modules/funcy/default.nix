{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "funcy";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "511495db0c5660af18d3151b008c6ce698ae7fbf60887278e79675e35eed1f01";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Collection of fancy functional tools focused on practicality";
    homepage = "http://funcy.readthedocs.org/";
    license = licenses.bsd3;
  };

}
