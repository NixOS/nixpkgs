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
    hash = "sha256-bpWy5kA5qV0PLNjzNg6vQY1rkBj7IhXYLTmdYtYSLcM=";
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
