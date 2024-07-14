{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
  glib,
}:

buildPythonPackage rec {
  pname = "bluepy";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KnHtr+EDVl+5kCVv82JMFlMDaoN9/JDh4yuDn4OXHOw=";
  };

  buildInputs = [ glib ];
  nativeBuildInputs = [ pkg-config ];

  # tests try to access hardware
  checkPhase = ''
    $out/bin/blescan --help > /dev/null
    $out/bin/sensortag --help > /dev/null
    $out/bin/thingy52 --help > /dev/null
  '';
  pythonImportsCheck = [ "bluepy" ];

  meta = with lib; {
    description = "Python interface to Bluetooth LE on Linux";
    homepage = "https://github.com/IanHarvey/bluepy";
    maintainers = with maintainers; [ georgewhewell ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
