{ stdenv, fetchPypi, buildPythonPackage, colorama }:

buildPythonPackage rec {
  pname = "crayons";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dcb85b87aa03bb65bd3a073d012796b024cabeb086033e616759e2abb769440b";
  };

  requiredPythonModules = [ colorama ];

  meta = with stdenv.lib; {
    description = "TextUI colors for Python";
    homepage = "https://github.com/kennethreitz/crayons";
    license = licenses.mit;
  };
}
