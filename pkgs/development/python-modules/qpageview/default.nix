{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  pyqt6,
  poppler-qt5,
  pycups,
}:

buildPythonPackage rec {
  pname = "qpageview";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frescobaldi";
    repo = "qpageview";
    tag = "v${version}";
    hash = "sha256-5D+fumQVCfl9ZEHIQmbdXkAuAkiKy6P5+StMWSE+a0A=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pyqt6
    poppler-qt5
    pycups
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "qpageview" ];

  meta = with lib; {
    description = "Page-based viewer widget for Qt5/PyQt5";
    homepage = "https://github.com/frescobaldi/qpageview";
    changelog = "https://github.com/frescobaldi/qpageview/blob/${src.tag}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ camillemndn ];
  };
}
