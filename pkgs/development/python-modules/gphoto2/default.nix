{ stdenv, fetchPypi, buildPythonPackage
, pkgconfig
, libgphoto2 }:

buildPythonPackage rec {
  pname = "gphoto2";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fdmlyy3lbc6ggfn60fjizaz5icxd676y7gz9nzfy3l4id7mfyk4";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libgphoto2 ];

  doCheck = false; # No tests available

  meta = with stdenv.lib; {
    description = "Python interface to libgphoto2";
    homepage = "https://github.com/jim-easterbrook/python-gphoto2";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
