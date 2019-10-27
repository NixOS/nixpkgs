{ stdenv, fetchPypi, buildPythonPackage
, pkgconfig
, libgphoto2 }:

buildPythonPackage rec {
  pname = "gphoto2";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01vcbjsy5zpfd9rzshk2d6150vhb66m5n420j0wd0k0i0p74ya98";
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
