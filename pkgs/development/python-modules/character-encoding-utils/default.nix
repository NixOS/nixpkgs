{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  nix-update-script,
  uv-build,
}:

buildPythonPackage rec {
  pname = "character-encoding-utils";
  version = "0.0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "character-encoding-utils";
    tag = version;
    hash = "sha256-4WaVvr6/d/oePtmwpGJ/D6tv10V/ok9iN4BrqGk97f0=";
  };

  build-system = [ uv-build ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "character_encoding_utils" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/character-encoding-utils";
    description = "Some character encoding utils";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
}
