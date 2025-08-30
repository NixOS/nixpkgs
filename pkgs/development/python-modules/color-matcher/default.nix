{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  imageio,
  docutils,
  ddt,
  matplotlib,
  packaging,
}:
let
  pname = "color-matcher";
  version = "0.6.0";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e6igB4LD5eWTHdp7H7nFcqzoLeDGyXZUQyt8/gqnSEM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    imageio
    docutils
    ddt
    matplotlib
    packaging
  ];

  postPatch = ''
    ln -s */requires.txt requirements.txt
  '';

  meta = {
    description = "Package enabling color transfer across images";
    homepage = "https://pypi.org/project/color-matcher/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ blenderfreaky ];
  };
}
