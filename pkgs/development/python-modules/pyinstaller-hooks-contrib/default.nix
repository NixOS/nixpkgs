{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "pyinstaller-hooks-contrib";
  version = "2021.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-f10GibMNowkhSfxTaoNalARayMnw5t+yOsFxiQ9eqPI=";
  };

  meta = with lib; {
    description = "Community maintained hooks for PyInstaller";
    homepage = "https://github.com/pyinstaller/pyinstaller-hooks-contrib";
    license = with licenses; [ asl20 gpl2Plus ];
    maintainers = with maintainers; [ kranzes ];
  };
}
