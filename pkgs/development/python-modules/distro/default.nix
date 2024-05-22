{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "distro";
  version = "1.9.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L6d8b9iUDxFu4da5Si+QsTteqNAZuYvIuv3KvN2b2+0=";
  };

  nativeBuildInputs = [ setuptools ];

  # tests are very targeted at individual linux distributions
  doCheck = false;

  pythonImportsCheck = [ "distro" ];

  meta = with lib; {
    homepage = "https://github.com/nir0s/distro";
    description = "Linux Distribution - a Linux OS platform information API.";
    mainProgram = "distro";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
