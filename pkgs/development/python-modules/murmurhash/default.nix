{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "murmurhash";
  version = "1.0.13";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c3JG1B7gD/dLB7C9HwiIvjBNIDzmaOZCyGqmTt4w+Lc=";
  };

  buildInputs = [ cython ];

  # No test
  doCheck = false;

  pythonImportsCheck = [ "murmurhash" ];

  meta = with lib; {
    description = "Cython bindings for MurmurHash2";
    homepage = "https://github.com/explosion/murmurhash";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
