{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pybase91";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "base91";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aul68hDvEriSOUAutJkboeP7rzLcZGC7va39GVqKmig=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-X9hVLZ5+oVsPWihOxaAQQMLOJhejNBQnRQgdk1sp3Lw=";
  };

  buildAndTestSubdir = "base91";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  maturinBuildFlags = [
    "--features"
    "python"
  ];

  pythonImportsCheck = [ "pybase91" ];

  meta = {
    description = "basE91 Python extension (Rust/PyO3)";
    homepage = "https://github.com/douzebis/base91";
    changelog = "https://github.com/douzebis/base91/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      bsd3
      mit
    ];
    maintainers = with lib.maintainers; [ douzebis ];
  };
})
