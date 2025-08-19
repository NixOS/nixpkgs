{
  lib,
  astunparse,
  buildPythonPackage,
  distutils,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pythonOlder,
  torch,
  torchvision,
}:

buildPythonPackage rec {
  pname = "fickling";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "fickling";
    tag = "v${version}";
    hash = "sha256-/cV1XhJ8KMFby9nZ/qXEYxf+P6352Q2DZOLuvebyuHQ=";
  };

  build-system = [
    distutils
    flit-core
  ];

  dependencies = [ astunparse ];

  optional-dependencies = {
    torch = [
      torch
      torchvision
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "fickling" ];

  meta = with lib; {
    description = "Python pickling decompiler and static analyzer";
    homepage = "https://github.com/trailofbits/fickling";
    changelog = "https://github.com/trailofbits/fickling/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
