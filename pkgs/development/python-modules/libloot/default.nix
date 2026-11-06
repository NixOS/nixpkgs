{
  buildPythonPackage,
  lib,
  libloot-native,
  rustPlatform,
}:

buildPythonPackage {
  inherit (libloot-native) version src cargoDeps; # nixpkgs-update: no auto update
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
    inherit (libloot-native.meta) license platforms;
    description = "Experimental Python wrapper around libloot";
    homepage = "https://github.com/loot/libloot/tree/master/python";
    maintainers = libloot-native.meta.maintainers ++ (with lib.maintainers; [ RoGreat ]);
  };
}
