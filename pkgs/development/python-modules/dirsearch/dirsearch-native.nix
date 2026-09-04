{
  buildPythonPackage,
  rustPlatform,
  # attributes from dirsearch
  src,
  meta,
}:
buildPythonPackage (finalAttrs: {
  pname = "dirsearch-native";
  version = "0.1.0";

  inherit src;
  sourceRoot = "${finalAttrs.src.name}/native";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-5LgxxVknZXMYkh9ozuUx0UGfDeuU2dzFy7nLPhlrvJs=";
  };

  pyproject = true;
  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];
  nativeCheckInputs = [
    rustPlatform.cargoCheckHook
  ];

  pythonImportsCheck = [ "dirsearch_native" ];

  meta = {
    description = "Rust native backend for dirsearch";
    inherit (meta)
      homepage
      changelog
      license
      maintainers
      ;
  };
})
