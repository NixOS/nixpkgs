{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "bitvavo-aio";
  version = "1.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "bitvavo-aio";
    rev = version;
    sha256 = "1d9nbbvv7xnkixj03sfhs2da5j3i2m7p73r7j1yb7b39zas2rbig";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "bitvavo" ];

  meta = {
    description = "Python client for Bitvavo crypto exchange API";
    homepage = "https://github.com/cyberjunky/bitvavo-aio";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
