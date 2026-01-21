{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  nix-update-script,
  hatchling,
  bdffont,
}:

buildPythonPackage rec {
  pname = "pcffont";
  version = "0.0.24";
  pyproject = true;

  src = fetchPypi {
    pname = "pcffont";
    inherit version;
    hash = "sha256-Sax3bUs6ogQ+LuUAy6k1zEfN4WT81zm1LzP2s/6Pecg=";
  };

  build-system = [ hatchling ];

  dependencies = [ bdffont ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pcffont" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/pcffont";
    description = "Library for manipulating Portable Compiled Format (PCF) Fonts";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
}
