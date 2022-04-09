{ lib, buildPythonPackage, fetchPypi, linuxHeaders }:

buildPythonPackage rec {
  pname = "evdev";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WzOxdPfIRXbn3WBx5Di/WtIn2pXv1DVqOf5Mg1VBL+Y=";
  };

  buildInputs = [ linuxHeaders ];

  patchPhase = ''
    substituteInPlace setup.py --replace /usr/include/linux ${linuxHeaders}/include/linux
  '';

  doCheck = false;

  meta = with lib; {
    description = "Provides bindings to the generic input event interface in Linux";
    homepage = "https://pythonhosted.org/evdev";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
