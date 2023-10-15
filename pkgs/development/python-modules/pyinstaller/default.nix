{ lib
, buildPythonPackage
, fetchPypi
, altgraph
, importlib-metadata
, packaging
, pefile
, setuptools
,zlib
,python3Packages
, bash
}:

buildPythonPackage rec {
  pname = "pyinstaller";
  version = "6.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1wLP8EHzDnpTUAtjDgewgeUyjUZVAjMZJT1zk151reI=";
  };

  propagatedBuildInputs = [
    altgraph
    importlib-metadata
    packaging
#    python3Packages.pyinstaller-hooks-contrib
    setuptools
    zlib
    packaging
    python3Packages.pyinstaller-hooks-contrib
    python3Packages.wheel
  ];
  nativeBuildInputs = [
    altgraph
    importlib-metadata
    packaging
#    python3Packages.pyinstaller-hooks-contrib
    setuptools
    zlib
    packaging
    python3Packages.pyinstaller-hooks-contrib
    python3Packages.wheel
  ];

#  pythonImportsCheck = [ "pyinstaller" ];

  meta = with lib; {
    description = "PyInstaller bundles a Python application and all its dependencies into a single package";
    homepage = "https://www.pyinstaller.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ provenzano ];
  };
}
