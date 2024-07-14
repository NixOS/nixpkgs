{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "hopcroftkarp";
  version = "1.2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KKeIfbga2ZXM02obUWSkxUKxbSeB6MSTNNydFBlowOc=";
  };

  # tests fail due to bad package name
  doCheck = false;

  meta = with lib; {
    description = "Implementation of HopcroftKarp's algorithm";
    homepage = "https://github.com/sofiat-olaosebikan/hopcroftkarp";
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
}
