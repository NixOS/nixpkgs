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
  pkg-config,
  zstd,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "raygeo";
  version = "1.68.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HrWFyXg2MdpNSm+KyKoAVo5PSEfeNFShMS7N3n7HZzk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-h8kwp7kK6qzrjjUBOa5wjn6oWSnMHFk/xqPAFtu0A7I=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kanagawamarcos ];
  };
}
