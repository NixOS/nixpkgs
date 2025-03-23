{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  flit-core,
  numpy,
  pydicom,
  pylibjpeg-data,
  pylibjpeg-libjpeg,
  pylibjpeg-openjpeg,
}:

buildPythonPackage rec {
  pname = "pylibjpeg";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pylibjpeg";
    tag = "v${version}";
    hash = "sha256-MA1A/hTIx95MYZ2LGOifnHn77wbv0ydAgQSzNZRykVg=";
  };

  build-system = [ flit-core ];

  dependencies = [ numpy ];

  optional-dependencies = {
    libjpeg = [ pylibjpeg-libjpeg ];
    openjpeg = [ pylibjpeg-openjpeg ];
    #rle = [ pylibjpeg-rle ]; # not in Nixpkgs
  };

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
