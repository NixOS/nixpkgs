{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python3Packages,
  pythonOlder,
}:

python3Packages.buildPythonPackage rec {
  pname = "qpageview";
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "frescobaldi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XFMTOD7ums8sbFHUViEI9q6/rCjUmEtXAdd3/OmLsHU=";
  };

  propagatedBuildInputs = with python3Packages; [
    pyqt5
    poppler-qt5
    pycups
  ];

  pythonImportsCheck = [ "qpageview" ];

  meta = with lib; {
    description = "Page-based viewer widget for Qt5/PyQt5";
    homepage = "https://github.com/frescobaldi/qpageview";
    changelog = "https://github.com/frescobaldi/qpageview/blob/${src.rev}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ camillemndn ];
  };
}
