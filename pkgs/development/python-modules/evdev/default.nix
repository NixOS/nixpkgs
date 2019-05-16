{ lib, buildPythonPackage, isPy34, fetchPypi, linuxHeaders }:

buildPythonPackage rec {
  pname = "evdev";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l837gm9cjdp3lybnam38ip0q3n1xy0j6vzgx11hdrr0ps8p5mid";
  };

  buildInputs = [ linuxHeaders ];

  patchPhase = ''
    substituteInPlace setup.py --replace /usr/include/linux ${linuxHeaders}/include/linux
  '';

  doCheck = false;

  disabled = isPy34;  # see http://bugs.python.org/issue21121

  meta = with lib; {
    description = "Provides bindings to the generic input event interface in Linux";
    homepage = https://pythonhosted.org/evdev;
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
