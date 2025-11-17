{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "liblp";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sebaubuntu-python";
    repo = "liblp";
    tag = "v${version}";
    hash = "sha256-F30D2mYUYPupbr8OsrcrN6wQ639L5OlzQw/FrxPCsC4=";
  };

  build-system = [ poetry-core ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "liblp" ];

  meta = {
    description = "Android logical partitions library ported from C++ to Python";
    homepage = "https://github.com/sebaubuntu-python/liblp";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "lpunpack";
  };
}
