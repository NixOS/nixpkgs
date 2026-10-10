{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "phpserialize";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v2ctMS0gPQmoTCY2b6uPQ4o/+zVcQH5pl0t+8tOaD6c=";
  };

  # project does not have tests at the moment
  doCheck = false;

  meta = {
    description = "Port of the serialize and unserialize functions of PHP to Python";
    homepage = "https://github.com/mitsuhiko/phpserialize";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
