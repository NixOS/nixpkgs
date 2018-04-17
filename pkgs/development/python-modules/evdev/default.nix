{ lib, buildPythonPackage, isPy34, fetchPypi, linuxHeaders }:

buildPythonPackage rec {
  pname = "evdev";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f10c22f15ffedb34519e4af2201f1a088a958efedfd50da0da1aa3887283dff";
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
