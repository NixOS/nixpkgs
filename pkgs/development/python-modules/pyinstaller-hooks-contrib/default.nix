{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyinstaller-hooks-contrib";
  version = "2023.1";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab56c192e7cd4472ff6b840cda4fc42bceccc7fb4234f064fc834a3248c0afdd";
  };


  doCheck = false;

  meta = with lib; {
    description = "PyInstaller community hooks";
    longDescription = ''
    A "hook" file extends PyInstaller to adapt it to the special needs and methods used by a Python package.
    The word "hook" is used for two kinds of files. A runtime hook helps the bootloader to launch an app,
    setting up the environment. A package hook (there are several types of those) tells PyInstaller
    what to include in the final app - such as the data files and (hidden) imports mentioned above.
    This repository is a collection of hooks for many packages, and allows PyInstaller to work with these packages seamlessly.
    '';
    homepage = "https://github.com/pyinstaller/pyinstaller-hooks-contrib";
    downloadPage = "https://pypi.org/project/pyinstaller-hooks-contrib";
    license = with licenses; [ gpl2Plus asl20 ];
    maintainers = with maintainers; [ septem9er ];
  };
}
