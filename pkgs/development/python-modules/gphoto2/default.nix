{ stdenv, fetchPypi, buildPythonPackage
, pkgconfig
, libgphoto2 }:

buildPythonPackage rec {
  pname = "gphoto2";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c8e0c3ca22c0a2bfd0f27d24be6e4da5fe315d39d51f5af7bb5da416dbfa4b7";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libgphoto2 ];

  doCheck = false; # No tests available

  meta = with stdenv.lib; {
    description = "Python interface to libgphoto2";
    homepage = https://github.com/jim-easterbrook/python-gphoto2;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
