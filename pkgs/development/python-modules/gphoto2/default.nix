{ lib, fetchPypi, buildPythonPackage
, pkg-config
, libgphoto2 }:

buildPythonPackage rec {
  pname = "gphoto2";
  version = "2.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mEbF/fOtw0cU/bx7DgQcmmJ/yqal8Hs/1KaLGC3e4/c=";
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
