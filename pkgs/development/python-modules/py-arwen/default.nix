{
  lib,
  buildPythonPackage,
  rustPlatform,
  arwen,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-arwen";
  pyproject = true;

  inherit (arwen)
    version
    src
    ;

  sourceRoot = "${finalAttrs.src.name}/py-arwen";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-SJ3RZ/kCfMJb26uaJEQzA2NXOCudyqbJpbvC4d/R/T8=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # conflicts with built module
    rm -r arwen
  '';

  pythonImportsCheck = [
    "arwen"
  ];

  meta = {
    inherit (arwen.meta)
      description
      homepage
      license
      platforms
      maintainers
      teams
      ;
  };
})
