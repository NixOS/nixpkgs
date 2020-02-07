{ lib, buildPythonPackage, fetchPypi, mock, pytest, urllib3 }:

buildPythonPackage rec {
  pname = "port-for";
  version = "0.4";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "47b5cb48f8e036497cd73b96de305cecb4070e9ecbc908724afcbd2224edccde";
  };
  
  propagatedBuildInputs = [ urllib3 ];
  
  # old dependency is used
  patchPhase = ''
    substituteInPlace port_for/_download_ranges.py --replace "urllib2" "urllib3" 
  '';
  
  checkInputs = [ mock pytest ];
  
  meta = with lib; {
    description = "Utility that helps with local TCP ports managment";
    homepage = "https://github.com/kmike/port-for";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
