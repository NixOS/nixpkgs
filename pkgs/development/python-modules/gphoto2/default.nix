{ lib, fetchPypi, buildPythonPackage
, pkg-config
, libgphoto2 }:

buildPythonPackage rec {
  pname = "gphoto2";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b1b52ec3004ad6a6927a015b0572878a0a56314caaf1e62b07550e7a2e09465";
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
