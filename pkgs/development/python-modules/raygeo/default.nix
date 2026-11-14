{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  pkg-config,
  pyprojectVersionPatchHook,
  rustPlatform,
  zstd,

  # dependencies
  msgpack,
  numpy,

  # test
  dejavu_fonts,
  makeFontsConf,
  pycairo,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "raygeo";
  version = "1.76.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "barebaric";
    repo = "raygeo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eTUM9mgt02i3e2g9kIaHCtPtetkSBGtBeMniwP/GH5U=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-0TyUurWGFKHgLvrLJBRFZC/0vWaLf+SxE+lnHMMT3WI=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    pyprojectVersionPatchHook
    pkg-config
  ];

  buildInputs = [ zstd ];

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
