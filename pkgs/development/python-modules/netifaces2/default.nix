{
  lib,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
}:
let
  pname = "netifaces2";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "SamuelYvon";
    repo = "netifaces-2";
    rev = "refs/tags/V${version}";
    hash = "sha256-XO3HWq8FOVzvpbK8mIBOup6hFMnhDpqOK/5bPziPZQ8=";
  };
in
buildPythonPackage {
  inherit pname version src;
  pyproject = true;

  disabled = pythonOlder "3.7";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-dkqI0P61ciGqPtBc/6my7osaxxO9pEgovZhlpo1HdkU=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "netifaces" ];

  meta = {
    description = "Portable network interface information";
    homepage = "https://github.com/SamuelYvon/netifaces-2";
    license = with lib.licenses; [ mit ];
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
