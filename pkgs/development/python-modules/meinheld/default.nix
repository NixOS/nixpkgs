{
  lib,
  stdenv,
  pythonAtLeast,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  greenlet,
}:

buildPythonPackage rec {
  pname = "meinheld";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AIx2k3rCEXzGngMtxpzqn4X8YF3pusFBf0R8QcFqVtY=";
  };

  pythonRelaxDeps = [ "greenlet" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=implicit-function-declaration";

  build-system = [ setuptools ];

  dependencies = [ greenlet ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "meinheld" ];

  meta = {
    description = "High performance asynchronous Python WSGI Web Server";
    homepage = "https://meinheld.org/";
    license = lib.licenses.bsd3;
  };
}
