{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bitvavo-aio";
  version = "1.0.3";
  format = "setuptools";
  disabled = pythonOlder "3.6";

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

  meta = with lib; {
    description = "Python client for Bitvavo crypto exchange API";
    homepage = "https://github.com/cyberjunky/bitvavo-aio";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
