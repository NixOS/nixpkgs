{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyqt5,
  setuptools-scm,
}:
buildPythonPackage {
  pname = "qtwidgets";
  version = "1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pythonguis";
    repo = "python-qtwidgets";
    rev = "89bd9dc53990f04a82bb27cb056f0c513e40e8b0";
    sha256 = "sha256-IoxNkuDR0jBh4EsTAzOBPAr5b4wEH5rLw2FAPSZj8Zo=";
  };

  patches = [
    ./fix-qtgui-import.patch
    ./fix-missing-svgs.patch
  ];

  build-inputs = [ setuptools-scm ];

  dependencies = [ pyqt5 ];

  doCheck = false; # no tests

  meta = {
    description = "Custom widget library for PyQt5 and PySide2";
    homepage = "https://github.com/pythonguis/python-qtwidgets";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ xyven1 ];
  };
}
