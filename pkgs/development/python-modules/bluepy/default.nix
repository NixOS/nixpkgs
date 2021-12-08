{ lib
, buildPythonPackage
, fetchFromGitHub
, pkg-config
, glib
}:

buildPythonPackage rec {
  pname = "bluepy";
  version = "1.3.0";

  src = fetchFromGitHub {
     owner = "IanHarvey";
     repo = "bluepy";
     rev = "v/1.3.0";
     sha256 = "0rlzq4rj929m8rn0391fpc4awpr2z1l4hv5wmba3vg610wzi8ak4";
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
