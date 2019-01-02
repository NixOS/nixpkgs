{ stdenv, fetchPypi, buildPythonPackage
, pkgconfig
, libgphoto2 }:

buildPythonPackage rec {
  pname = "gphoto2";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dx4pxnl3nmmgfpzalcxscay6pyswkk4pli71zyjn2icl8y0r3lw";
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
