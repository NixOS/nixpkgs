{ lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "data_hacks";
  version = "0.3.1";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "aa047cec15f6577ef2e1d1c0de45e4fe160da0ce92c8d956636fd35c8d6efc15";
  };
    
  meta = with lib; {
    description = "Command line utilities for data analysis";
    homepage = "https://github.com/bitly/data_hacks";
    license = licenses.unlicense;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
