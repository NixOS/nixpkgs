{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pyqt5,
  poppler-qt5,
  pycups,
}:

buildPythonPackage rec {
  pname = "qpageview";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "frescobaldi";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-UADC+DH3eG1pqlC9BRsqGQQjJcpfwWWVq4O7aFGLxLA=";
  };

  propagatedBuildInputs = [
    pyqt5
    poppler-qt5
    pycups
  ];

  pythonImportsCheck = [ "qpageview" ];

  meta = with lib; {
    description = "Page-based viewer widget for Qt5/PyQt5";
    homepage = "https://github.com/frescobaldi/qpageview";
    changelog = "https://github.com/frescobaldi/qpageview/blob/${src.tag}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ camillemndn ];
  };
}
