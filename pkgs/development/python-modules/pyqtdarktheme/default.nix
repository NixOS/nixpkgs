{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  python3Packages,
}:
buildPythonPackage rec {
  pname = "pyqtdarktheme";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "5yutan5";
    repo = "PyQtDarkTheme";
    rev = "v${version}";
    hash = "sha256-jK+wnIyPE8Bav0pzbvVisYYCzdRshYw1S2t0H3Pro5M=";
  };

  patches = [./argument.patch];

  propagatedBuildInputs = with python3Packages; [poetry-core darkdetect];

  meta = with lib; {
    description = "A flat dark theme for PySide and PyQt";
    homepage = "A flat dark theme for PySide and PyQt";
    license = licenses.mit;
    maintainers = [maintainers.rasmusrendal];
  };
}
