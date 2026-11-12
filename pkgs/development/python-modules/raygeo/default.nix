{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustc,
  rustPlatform,
  msgpack,
  numpy,
  dejavu_fonts,
  makeFontsConf,
  pycairo,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "raygeo";
  version = "1.68.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "barebaric";
    repo = "raygeo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MBy5lKXwAK+gobegNEKUdBLuh1br6z778wLMcYCqk0g=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-3LkEttV4JYGxtEmIZCtihE6LZRP0F0naitb19OARtB8=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  dependencies = [
    msgpack
    numpy
  ];

  nativeCheckInputs = [
    pycairo
    pytestCheckHook
  ];

  # The text-to-geometry tests render with the DejaVu Sans family and the
  # layout tests derive their assertions from real glyph metrics.
  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ dejavu_fonts ]; };

  pythonImportsCheck = [ "raygeo" ];

  meta = {
    description = "High-performance 2D/3D geometry library backed by Rust";
    homepage = "https://github.com/barebaric/raygeo";
    changelog = "https://github.com/barebaric/raygeo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kanagawamarcos ];
  };
})
