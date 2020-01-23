{ lib, buildPythonPackage, fetchPypi, pip, setuptools }:

buildPythonPackage rec {
  pname = "pipdeptree";
  version = "0.13.2";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "f54a2388cfe3cbaa08f4702ee8957f0f3f0d6ff65899833ea57f12f2fc4ae0c1";
  };
  
  propagatedBuildInputs = [ pip setuptools ];
  
  meta = with lib; {
    description = "Command line utility to show dependency tree of packages";
    homepage = "https://github.com/naiquevin/pipdeptree";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
