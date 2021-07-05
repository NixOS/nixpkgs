{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "PyInstaller";
  version = "4.3";

  src = fetchPypi {
    pname = "pyinstaller";
    inherit version;
    sha256 = "sha256-Xs+LvCMNcpinluUrt0W5Xu4Sh40UHxZFYSyZJG7NI/I=";
  };

  propagatedBuildInputs = with python3Packages; [
    altgraph
    pyinstaller-hooks-contrib
    macholib
  ];

  doCheck = false;

  meta = with lib; {
    description = "Freeze (package) Python programs into stand-alone executables";
    homepage = "http://www.pyinstaller.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kranzes ];
  };
}
