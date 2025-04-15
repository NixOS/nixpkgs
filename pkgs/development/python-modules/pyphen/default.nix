{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyphen";
  version = "0.17.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9gZHqcmzDsbFmRAJevgrxd0tNldrkY5EFI2LB+87SqM=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyphen" ];

  meta = with lib; {
    description = "Module to hyphenate text";
    homepage = "https://github.com/Kozea/Pyphen";
    changelog = "https://github.com/Kozea/Pyphen/releases/tag/${version}";
    license = with licenses; [
      gpl2
      lgpl21
      mpl20
    ];
  };
}
