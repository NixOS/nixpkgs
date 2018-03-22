{ lib, buildPythonPackage, isPy34, fetchPypi, linuxHeaders }:

buildPythonPackage rec {
  pname = "evdev";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "188ahmqnh5y1f46m7pyjdmi9zfxswaggn6xga65za554d72azvap";
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
