{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pyskyqhub";
  version = "0.1.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "RogerSelwyn";
    repo = "skyq_hub";
    rev = version;
    hash = "sha256-yXqtABbsCh1yb96lsEA0gquikVenGLCo6J93AeXAC8k=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Tests require physical hardware
  doCheck = false;

  pythonImportsCheck = [ "pyskyqhub" ];

  meta = {
    description = "Python module for accessing SkyQ Hub";
    homepage = "https://github.com/RogerSelwyn/skyq_hub";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
