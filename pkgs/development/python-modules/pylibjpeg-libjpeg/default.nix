{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  cython,
  poetry-core,
  setuptools,
  numpy,
  gdcm,
  pydicom,
  pylibjpeg-data,
}:

buildPythonPackage rec {
  pname = "pylibjpeg-libjpeg";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pylibjpeg-libjpeg";
    rev = "refs/tags/v${version}";
    hash = "sha256-g4dGIGHo0J+F0KTVA6yjgfwiYVn6iU69jgHhvEQGwOc=";
    fetchSubmodules = true;
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    gdcm
    pydicom
    pylibjpeg-data
    pytestCheckHook
  ];

  pythonImportsCheck = [ "libjpeg" ];

  meta = {
    description = "JPEG, JPEG-LS and JPEG XT plugin for pylibjpeg";
    homepage = "https://github.com/pydicom/pylibjpeg-libjpeg";
    changelog = "https://github.com/pydicom/pylibjpeg-libjpeg/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
