{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "py2bit";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SXL4XrOETN+6Q+tUqzyDSaBTbgPf19sHyo00Ryha0gw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [ "py2bitTest/test.py" ];

  meta = {
    homepage = "https://github.com/deeptools/py2bit";
    description = "File access to 2bit files";
    longDescription = ''
      A python extension, written in C, for quick access to 2bit files. The extension uses lib2bit for file access.
    '';
    license = lib.licenses.mit;
  };
}
