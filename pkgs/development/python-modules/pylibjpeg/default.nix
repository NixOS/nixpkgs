{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  flit-core,
  setuptools,
  numpy,
  pydicom,
  pylibjpeg-libjpeg,
}:

let
  pylibjpeg-data = buildPythonPackage {
    pname = "pylibjpeg-data";
    version = "1.0.0dev0";
    pyproject = true;

    nativeBuildInputs = [ setuptools ];

    src = fetchFromGitHub {
      owner = "pydicom";
      repo = "pylibjpeg-data";
      rev = "2ab4b8a65b070656eca2582bd23197a3d01cdccd";
      hash = "sha256-cFE1XjrqyGqwHCYGRucXK+q4k7ftUIbYwBw4WwIFtEc=";
    };

    doCheck = false;
  };
in

buildPythonPackage rec {
  pname = "pylibjpeg";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pylibjpeg";
    rev = "refs/tags/v${version}";
    hash = "sha256-qGtrphsBBVieGS/8rdymbsjLMU/QEd7zFNAANN8bD+k=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    pydicom
    pylibjpeg-data
    pylibjpeg-libjpeg
  ];

  pythonImportsCheck = [ "pylibjpeg" ];

  meta = with lib; {
    description = "Python framework for decoding JPEG images, with a focus on supporting Pydicom";
    homepage = "https://github.com/pydicom/pylibjpeg";
    changelog = "https://github.com/pydicom/pylibjpeg/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
