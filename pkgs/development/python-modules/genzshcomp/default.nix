{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "genzshcomp";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b582910d36f9ad0992756d7e9ccbe3e5cf811934b1002b51f25b99d3dda9d573";
  };

  buildInputs = [ setuptools ];

  meta = with lib; {
    description = "Automatically generated zsh completion function for Python's option parser modules";
    homepage = "https://bitbucket.org/hhatto/genzshcomp/";
    license = licenses.bsd0;
  };

}
