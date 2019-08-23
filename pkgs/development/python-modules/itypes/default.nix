{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "itypes";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6e77bb9fd68a4bfeb9d958fea421802282451a25bac4913ec94db82a899c073";
  };

  # Pypi does not provide test files
  doCheck = false;

  meta = with lib; {
    description = "Basic immutable container types for Python";
    license = licenses.bsd3;
    homepage = "https://github.com/tomchristie/itypes";
  };
}
