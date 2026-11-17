{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "daemonize";
  version = "2.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-3QJuT/jSLLAW7SEwvHOLfUsdpZfvk8B00q255N6gi8M=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "daemonize" ];

  meta = {
    description = "Library to enable your code run as a daemon process on Unix-like systems";
    homepage = "https://github.com/thesharp/daemonize";
    license = lib.licenses.mit;
  };
})
