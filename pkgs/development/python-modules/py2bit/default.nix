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
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jk9b/DnXKfGsrVTHYKwE+oog1BhPS1BdnDM9LgMlN3A=";
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
    maintainers = with lib.maintainers; [ scalavision ];
  };
}
