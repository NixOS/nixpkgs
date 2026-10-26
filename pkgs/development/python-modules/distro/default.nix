{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "distro";
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-L6d8b9iUDxFu4da5Si+QsTteqNAZuYvIuv3KvN2b2+0=";
  };

  nativeBuildInputs = [ setuptools ];

  # tests are very targeted at individual linux distributions
  doCheck = false;

  pythonImportsCheck = [ "distro" ];

  meta = {
    homepage = "https://github.com/nir0s/distro";
    description = "Linux Distribution - a Linux OS platform information API";
    mainProgram = "distro";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
