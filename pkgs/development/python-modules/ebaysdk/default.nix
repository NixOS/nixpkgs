{
  lib,
  buildPythonPackage,
  fetchPypi,
  lxml,
  requests,
}:

buildPythonPackage rec {
  pname = "ebaysdk";
  version = "2.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lrh11wa0gfWcqN0wdFON9+UZaBT5zhLQ74RpA0Opx/M=";
  };

  propagatedBuildInputs = [
    lxml
    requests
  ];

  # requires network
  doCheck = false;

  meta = {
    description = "eBay SDK for Python";
    homepage = "https://github.com/timotheus/ebaysdk-python";
    license = lib.licenses.cddl;
    maintainers = [ lib.maintainers.mkg20001 ];
  };
}
