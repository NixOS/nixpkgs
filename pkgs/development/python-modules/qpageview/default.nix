{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  pyqt6,
  pycups,
}:

buildPythonPackage rec {
  pname = "qpageview";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frescobaldi";
    repo = "qpageview";
    tag = "v${version}";
    hash = "sha256-cKidVtsqNXGuWNTTgvVOP3Wyf6M+Xctwaq7pOZb8eeo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pyqt6
    pycups
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "qpageview" ];

  meta = {
    description = "Page-based viewer widget for Qt6/PyQt6";
    homepage = "https://github.com/frescobaldi/qpageview";
    changelog = "https://github.com/frescobaldi/qpageview/blob/${src.tag}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ camillemndn ];
  };
}
