{
  buildPythonPackage,
  lib,
  pkgs,
  rustPlatform,
}:

buildPythonPackage {
  inherit (pkgs.libloot) version src cargoDeps; # nixpkgs-update: no auto update
  pname = "libloot";
  pyproject = true;

  buildAndTestSubdir = "python";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "loot" ];

  __structuredAttrs = true;

  meta = {
    inherit (pkgs.libloot.meta) license platforms;
    description = "Experimental Python wrapper around libloot";
    homepage = "https://github.com/loot/libloot/tree/master/python";
    maintainers = pkgs.libloot.meta.maintainers ++ (with lib.maintainers; [ RoGreat ]);
  };
}
