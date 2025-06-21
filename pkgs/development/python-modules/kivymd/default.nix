{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  kivy,
  pillow,
  materialyoucolor,
  asynckivy,
}:

buildPythonPackage rec {
  pname = "kivymd";
  version = "1.1.1";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "kivymd";
    repo = "KivyMD";
    rev = version;
    hash = "sha256-svCBtdqGTW9aIG/MEZEsZ/w6nRiL/uP4Wh6TUlmj+do=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    kivy
    pillow
    materialyoucolor
    asynckivy
  ];

  # Ensure kivy does not try to create files on disk when imported during check
  KIVY_NO_CONFIG = 1;
  KIVY_NO_FILELOG = 1;
  pythonImportsCheck = [ "kivymd" ];

  meta = with lib; {
    description = "A collection of Material Design compliant widgets for use with Kivy, a framework for cross-platform, touch-enabled graphical applications.";
    homepage = "https://kivymd.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ iofq ];
  };
}
