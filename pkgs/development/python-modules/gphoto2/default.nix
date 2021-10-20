{ lib, fetchPypi, buildPythonPackage
, pkg-config
, libgphoto2 }:

buildPythonPackage rec {
  pname = "gphoto2";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a208264ed252a39b29a0b0f7ccc4c4ffb941398715aec84c3a547281a43c4eb8";
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
