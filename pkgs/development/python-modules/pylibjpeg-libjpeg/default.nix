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
}:

buildPythonPackage rec {
  pname = "pylibjpeg-libjpeg";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-iU40QdAY5931YM3h3P+WCbiBfX88iVi2QdUvZLptsFs=";
    fetchSubmodules = true;
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = false; # tests try to import 'libjpeg.data', which errors

  pythonImportsCheck = [ "libjpeg" ];

  meta = with lib; {
    description = "JPEG, JPEG-LS and JPEG XT plugin for pylibjpeg";
    homepage = "https://github.com/pydicom/pylibjpeg-libjpeg";
    changelog = "https://github.com/pydicom/pylibjpeg-libjpeg/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
