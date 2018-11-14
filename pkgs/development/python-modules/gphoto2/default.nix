{ stdenv, fetchPypi, buildPythonPackage
, pkgconfig
, libgphoto2 }:

buildPythonPackage rec {
  pname = "gphoto2";
  version = "1.8.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jvwq7qjr2iazmwdzkmr82iza7snylpm6x0kr9p0z5mkicg1l38l";
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
