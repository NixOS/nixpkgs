{ lib, buildPythonPackage, isPy34, fetchPypi, linuxHeaders }:

buildPythonPackage rec {
  pname = "evdev";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be0288ef1125bf1c539bb8f3079ef4aa5fb813af28f0c5294a4e744ee554398a";
  };

  buildInputs = [ linuxHeaders ];

  patchPhase = ''
    substituteInPlace setup.py --replace /usr/include/linux ${linuxHeaders}/include/linux
  '';

  doCheck = false;

  disabled = isPy34;  # see http://bugs.python.org/issue21121

  meta = with lib; {
    description = "Provides bindings to the generic input event interface in Linux";
    homepage = http://pythonhosted.org/evdev;
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
