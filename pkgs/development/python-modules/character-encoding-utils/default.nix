{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  nix-update-script,
  hatchling,
}:

buildPythonPackage rec {
  pname = "character-encoding-utils";
  version = "0.0.9";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "character_encoding_utils";
    inherit version;
    hash = "sha256-QxnXNerl7qncoBxhfC3G0ar+YprfBpn6pWnUKakNR+c=";
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
