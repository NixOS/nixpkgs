{ lib, stdenv, buildPythonPackage, fetchPypi, pam }:

buildPythonPackage rec {
  pname = "python-pam";
  version = "1.8.4";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "c856d9c89fedb33951dd8a95727ae57c6887b02d065bbdffd2fd9dbc0183909b";
  };
  
  # ctypes.util.find_library does not work on Nix
  patchPhase = ''
    substituteInPlace pam.py --replace 'find_library("pam")' '"${pam.out}/lib/libpam${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';
  
  # there is no test code for this module
  doCheck = false;
  
  meta = with lib; {
    description = "Python PAM module using ctypes";
    homepage = "https://github.com/FirefighterBlu3/python-pam";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
