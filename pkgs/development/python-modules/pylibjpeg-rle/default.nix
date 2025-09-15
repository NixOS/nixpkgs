{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  numpy,
  pydicom,
  pylibjpeg-data,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylibjpeg-rle";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pylibjpeg-rle";
    tag = "v${version}";
    hash = "sha256-S9QBZEYfM9cwhwycF9TDpHv44z6fXTu3wBr4ZZHxXR8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-ZkaDnG7wXQeaefASdsUFxuDKxjLukczyJeUgfG9uIyo=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pydicom
    pylibjpeg-data
    pytestCheckHook
  ];

  preCheck = ''
    mv rle/tests .
    rm -r rle
  '';

  pythonImportsCheck = [
    "rle"
    "rle.rle"
    "rle.utils"
  ];

  meta = {
    description = "Fast DICOM RLE plugin for pylibjpeg";
    homepage = "https://github.com/pydicom/pylibjpeg-rle";
    changelog = "https://github.com/pydicom/pylibjpeg-rle/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
