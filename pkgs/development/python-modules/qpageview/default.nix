{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pyqt5
, poppler-qt5
, pycups
}:

buildPythonPackage rec {
  pname = "qpageview";
  version = "0.6.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "frescobaldi";
    repo = "qpageview";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-XFMTOD7ums8sbFHUViEI9q6/rCjUmEtXAdd3/OmLsHU";
  };

  propagatedBuildInputs = [ pyqt5 poppler-qt5 pycups ];

  meta = with lib; {
    description = "A page based document viewer widget for Qt5/PyQt5";
    homepage = "https://qpageview.org/";
    # Licensing is a little unclear, https://github.com/frescobaldi/qpageview/issues/15
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.ceres ];
  };
}
