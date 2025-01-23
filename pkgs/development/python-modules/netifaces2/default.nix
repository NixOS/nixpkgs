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
    tag = "V${version}";
    hash = "sha256-XO3HWq8FOVzvpbK8mIBOup6hFMnhDpqOK/5bPziPZQ8=";
  };
in
buildPythonPackage {
  inherit pname version src;
  pyproject = true;

  disabled = pythonOlder "3.7";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-n8IDl1msu2wn6YSsRJDy48M8qo96cXD8n+2HeU2WspE=";
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
