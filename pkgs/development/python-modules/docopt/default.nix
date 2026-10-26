{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "docopt";
  version = "0.6.2";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-SbOoJSgL1ms6qDWF71nEqMgvLIpSLb51SovI0IyFxJE=";
  };

  meta = {
    description = "Pythonic argument parser, that will make you smile";
    homepage = "http://docopt.org/";
    license = lib.licenses.mit;
  };
})
