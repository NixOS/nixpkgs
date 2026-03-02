{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  nix-update-script,
  hatchling,
}:

buildPythonPackage rec {
  pname = "character-encoding-utils";
  version = "0.0.12";
  pyproject = true;

  src = fetchPypi {
    pname = "character_encoding_utils";
    inherit version;
    hash = "sha256-sOXdpO7c2EpbNbJK1WIYx/Xb5UGIMW8daw154V/NpU0=";
  };

  build-system = [ hatchling ];

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
