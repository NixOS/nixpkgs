{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py2bit";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deeptools";
    repo = "py2bit";
    tag = version;
    hash = "sha256-zuzepYX1iQM9BXWCyfvn39yOgqBQTC0tqU6nLGZd9TQ=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "py2bitTest/test.py" ];

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
