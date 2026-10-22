{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "hopcroftkarp";
  version = "1.2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-KKeIfbga2ZXM02obUWSkxUKxbSeB6MSTNNydFBlowOc=";
  };

  # tests fail due to bad package name
  doCheck = false;

  meta = {
    description = "Implementation of HopcroftKarp's algorithm";
    homepage = "https://github.com/sofiat-olaosebikan/hopcroftkarp";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})
