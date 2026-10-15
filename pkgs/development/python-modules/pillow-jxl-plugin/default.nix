{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  fetchPypi,
  rustPlatform,
  maturin,
  cmake,
  packaging,
  pillow,
  numpy,
  openexr,
  pyexiv2,
}:

buildPythonPackage (finalAttrs: {
  pname = "pillow-jxl-plugin";
  version = "1.3.8";
  pyproject = true;
  __structuredAttrs = true;

  # Contains Cargo.lock
  src = fetchPypi {
    pname = "pillow_jxl_plugin";
    inherit (finalAttrs) version;
    hash = "sha256-RDD9d1eJl0IHnFSKfSU31tY88PHTIxgAlbwPbwPZ1Po=";
  };

  build-system = [ maturin ];

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    cmake
  ];

  dontUseCmakeConfigure = true;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-IiVTlKtKkfZnRXme7QFA5MS8PPiL8+riOYOEoNaHHXc=";
  };

  dependencies = [
    packaging
    pillow
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    openexr
    pyexiv2
  ];

  # Remove source so tests don't try to import from it
  preCheck = ''
    rm -r pillow_jxl
  '';

  pythonImportsCheck = [
    "pillow_jxl"
  ];

  meta = {
    changelog = "https://github.com/Isotr0py/pillow-jpegxl-plugin/releases/tag/v${finalAttrs.version}";
    description = "Pillow plugin that adds support for JPEG XL files";
    homepage = "https://github.com/Isotr0py/pillow-jpegxl-plugin";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dandellion
      KunyaKud
    ];
  };
})
