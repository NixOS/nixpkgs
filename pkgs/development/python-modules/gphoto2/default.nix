{
  lib,
  fetchPypi,
  buildPythonPackage,
  pkg-config,
  libgphoto2,
  setuptools,
  toml,
}:

buildPythonPackage rec {
  pname = "gphoto2";
  version = "2.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jgh7ff+iUaeNQtBsXw2Jm+2gj1ctvrY3oahGrbxx3uE=";
  };

  nativeBuildInputs = [
    pkg-config
    setuptools
    toml
  ];

  buildInputs = [ libgphoto2 ];

  doCheck = false; # No tests available

  pythonImportsCheck = [ "gphoto2" ];

  meta = with lib; {
    description = "Python interface to libgphoto2";
    homepage = "https://github.com/jim-easterbrook/python-gphoto2";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
