{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, nix-update-script
, hatch-vcs
, hatchling
}:

buildPythonPackage rec {
  pname = "character-encoding-utils";
  version = "0.0.7";

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "character_encoding_utils";
    inherit version;
    hash = "sha256-cUggyNz5xphDF+7dSrx3vr3v3R8ISryHj9accMJfDbg=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  checkInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/character-encoding-utils";
    description = "Some character encoding utils";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ h7x4 ];
  };
}
