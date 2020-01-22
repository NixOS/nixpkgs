{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "inotify";
  version = "0.2.10";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "974a623a338482b62e16d4eb705fb863ed33ec178680fc3e96ccdf0df6c02a07";
  };
    
  propagatedBuildInputs = [ nose ];
	
  meta = with lib; {
    description = "Adapter to Linux kernel support for inotify directory-watching";
    homepage = "https://github.com/dsoprea/PyInotify";
    license = licenses.gpl2;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}

