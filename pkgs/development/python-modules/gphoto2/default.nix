{ lib, fetchPypi, buildPythonPackage
, pkg-config
, libgphoto2 }:

buildPythonPackage rec {
  pname = "gphoto2";
  version = "2.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "48b4c4ab70826d3ddaaf7440564d513c02d78680fa690994b0640d383ffb8a7d";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgphoto2 ];

  doCheck = false; # No tests available

  meta = with lib; {
    description = "Python interface to libgphoto2";
    homepage = "https://github.com/jim-easterbrook/python-gphoto2";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
