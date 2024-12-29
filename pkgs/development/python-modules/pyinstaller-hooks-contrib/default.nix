{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyinstaller-hooks-contrib";
  version = "2024.10";

  pyproject = true;

  src = fetchPypi {
    pname = "pyinstaller_hooks_contrib";
    inherit version;
    hash = "sha256-ikZlXlxbAYa15Sc5kRips0LxBRPrFCXEg/pPbQLogAw=";
  };

  build-system = [ setuptools ];

  # There are tests for every hook, which means that
  # new updates are going to require changes to test inputs
  # and building tests creates a very big closure.
  doCheck = false;

  meta = {
    description = "Community maintained hooks for PyInstaller";
    longDescription = ''
      A "hook" file extends PyInstaller to adapt it to the special needs and methods used by a Python package.
      The word "hook" is used for two kinds of files. A runtime hook helps the bootloader to launch an app,
      setting up the environment. A package hook (there are several types of those) tells PyInstaller
      what to include in the final app - such as the data files and (hidden) imports mentioned above.
      This repository is a collection of hooks for many packages, and allows PyInstaller to work with these packages seamlessly.
    '';
    homepage = "https://github.com/pyinstaller/pyinstaller-hooks-contrib";
    # See https://github.com/pyinstaller/pyinstaller-hooks-contrib/issues/761
    changelog = "https://github.com/pyinstaller/pyinstaller-hooks-contrib/blob/master/CHANGELOG.rst";
    license = with lib.licenses; [
      gpl2Plus
      asl20
    ];
    maintainers = with lib.maintainers; [ h7x4 ];
  };
}
