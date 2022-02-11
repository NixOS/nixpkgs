{ lib, buildPythonPackage, fetchPypi, linuxHeaders }:

buildPythonPackage rec {
  pname = "evdev";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8782740eb1a86b187334c07feb5127d3faa0b236e113206dfe3ae8f77fb1aaf1";
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
