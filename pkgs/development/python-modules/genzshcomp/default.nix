{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "genzshcomp";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tYKRDTb5rQmSdW1+nMvj5c+BGTSxACtR8luZ092p1XM=";
  };

  buildInputs = [ setuptools ];

  meta = with lib; {
    description = "Automatically generated zsh completion function for Python's option parser modules";
    mainProgram = "genzshcomp";
    homepage = "https://bitbucket.org/hhatto/genzshcomp/";
    license = licenses.bsd0;
  };
}
