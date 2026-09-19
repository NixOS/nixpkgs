{
  buildPythonPackage,
  rustPlatform,
  pythonOlder,
  # attributes from dirsearch
  src,
  meta,
}:
buildPythonPackage (finalAttrs: {
  pname = "dirsearch-native";
  # dirsearchs updateScript will fail if upstream bumps the version string for dirsearch_native.
  # I don't think there is anything I can do about until upstream either releases the 2 python
  # packages separately or versions them alongside each other
  # upstream issue https://github.com/maurosoria/dirsearch/issues/1640
  version = "0.1.0";

  disabled = pythonOlder "3.14";

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
