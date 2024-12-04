{
  lib,
  buildPythonPackage,
  isPy27,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "sansio-multipart";
  version = "0.3";

  disabled = isPy27;

  format = "setuptools";

  src = fetchPypi {
    pname = "sansio_multipart";
    inherit version;
    sha256 = "6e95b2e64039a95d0f2cd8f3360eaf418d6b9018fb2215d82d399d62d6122dc3";
  };

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "sansio_multipart" ];

  meta = {
    description = "Parser for multipart/form-data";
    homepage = "https://github.com/theelous3/sansio-multipart-parser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
