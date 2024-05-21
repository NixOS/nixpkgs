{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "character-encoding-utils";
  version = "0.0.8";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "character_encoding_utils";
    inherit version;
    hash = "sha256-UXX4L/x7fP37ZEFDCPc0KRNyx47xvwY0Jz+lfxzUulg=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "character_encoding_utils" ];

  meta = {
    description = "Some character encoding utils";
    homepage = "https://github.com/TakWolf/character-encoding-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ h7x4 ];
  };
}
