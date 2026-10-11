{
  buildPythonPackage,
  fetchFromGitHub,
  git,
  lib,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "libloot";
  version = "0.29.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "loot";
    repo = "libloot";
    tag = finalAttrs.version;
    hash = "sha256-Pz13z0uQfTeo47NJORfZ8n8ucqZdoLVGNIsrf2+OOGA=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";
  cargoRoot = "..";

  nativeBuildInputs = [
    git
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-IQowGdrol/JFoh+hGfhwoJ2FumkvbuZsp8Xx/V2hFdw=";
  };

  env = {
    CARGO_TARGET_DIR = "./target";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "loot" ];

  __structuredAttrs = true;

  meta = {
    description = "Experimental Python wrapper around libloot";
    homepage = "https://github.com/loot/libloot/tree/master/python";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ RoGreat ];
    platforms = lib.platforms.linux;
  };
})
