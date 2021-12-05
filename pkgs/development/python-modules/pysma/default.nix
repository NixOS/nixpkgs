{ lib, aiohttp, attrs, buildPythonPackage, fetchPypi, jmespath, pythonOlder }:

buildPythonPackage rec {
  pname = "pysma";
  version = "0.6.9";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2ZU3UjDNo+fpnYK4WlYSu7XqkbpcK7Xz5cUKDABhwdk=";
  };

  propagatedBuildInputs = [ aiohttp attrs jmespath ];

  # pypi does not contain tests and GitHub archive not available
  doCheck = false;

  pythonImportsCheck = [ "pysma" ];

  meta = with lib; {
    description = "Python library for interacting with SMA Solar's WebConnect";
    homepage = "https://github.com/kellerza/pysma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
