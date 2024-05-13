{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, bdffont
, pytestCheckHook
, nix-update-script
}:

buildPythonPackage rec {
  pname = "pcffont";
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "pcffont";
    rev = "refs/tags/${version}";
    hash = "sha256-gu9niWxYTw3rcA++z8B+MdKp5XaqAGjmvd+PdSDosfg=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    bdffont
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pcffont" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library for manipulating Portable Compiled Format (PCF) fonts";
    homepage = "https://github.com/TakWolf/pcffont";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
