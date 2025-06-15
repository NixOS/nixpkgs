{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  kivy,
  pillow,
  materialyoucolor,
}:

buildPythonPackage rec {
  pname = "kivymd";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kxoENcKgecbcp1XFDQAjteHJB/e0rIu54oNNqjzv6QY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    kivy
    pillow
    materialyoucolor
  ];

  meta = with lib; {
    description = "A collection of Material Design compliant widgets for use with Kivy, a framework for cross-platform, touch-enabled graphical applications.";
    homepage = "https://kivymd.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ iofq ];
  };
}
