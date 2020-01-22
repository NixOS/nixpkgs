{ lib, buildPythonPackage, fetchPypi, nbconvert, requests }:

buildPythonPackage rec {
  pname = "nbconflux";
  version = "0.7.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "558e1ec23be44b4ea8fd383094dd89b0b023051cedb6e12889cc590f00bd1fa8";
  };
    
  propagatedBuildInputs = [ nbconvert requests ];
  
  meta = with lib; {
    description = "Converts Jupyter Notebooks to Atlassian Confluence (R) pages using nbconvert";
    homepage = "https://github.com/Valassis-Digital-Media/nbconflux";
    license = licenses.bsd3;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
