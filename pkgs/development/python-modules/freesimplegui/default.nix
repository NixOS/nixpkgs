{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  tkinter,
}:

buildPythonPackage rec {
  pname = "freesimplegui";
  version = "5.2.0.post1";
  pyproject = true;

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "spyoungtech";
    repo = "FreeSimpleGUI";
    tag = "v${version}";
    hash = "sha256-QR/+LbeELg1Yk0GtWbvQAq48hI086SqOIIXYkMgnVZ4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    tkinter
  ];

  pythonImportsCheck = [ "FreeSimpleGUI" ];

  meta = with lib; {
    description = "GUI library for Python";
    homepage = "https://freesimplegui.readthedocs.io";
    changelog = "https://github.com/spyoungtech/FreeSimpleGUI/releases";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ codebam ];
  };
}
