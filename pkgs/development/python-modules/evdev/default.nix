{ lib, buildPythonPackage, fetchPypi, linuxHeaders }:

buildPythonPackage rec {
  pname = "evdev";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b03f5e1be5b4a5327494a981b831d251a142b09e8778eda1a8b53eba91100166";
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
