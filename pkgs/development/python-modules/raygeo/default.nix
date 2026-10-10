{
  lib,
  buildPythonPackage,
  fetchPypi,
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

buildPythonPackage rec {
  pname = "raygeo";
  version = "1.61.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4oy/gCMPGAAcuJVSQBduagw6AHCRXP/WpuL5UJ0sxpQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-OxnLS0MbhfpNNJ6l0XNCdcBLU8S9JmpgYTr9sdzlkHQ=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kanagawamarcos ];
  };
}
