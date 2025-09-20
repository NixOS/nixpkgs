{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  nasm,
  pkg-config,
  setuptools,

  # native dependencies
  libheif,
  libaom,
  libde265,
  x265,

  # dependencies
  pillow,

  # tests
  opencv4,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pillow-heif";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bigcat88";
    repo = "pillow_heif";
    tag = "v${version}";
    hash = "sha256-CY//orCEKBfgHF7lTTSMenDsvf9NOQo8iiQS3p9NMH8=";
  };

  postPatch = ''
    sed -i '/addopts/d' pyproject.toml
    substituteInPlace setup.py \
      --replace-warn ', "-Werror"' ""
  '';

  nativeBuildInputs = [
    cmake
    nasm
    pkg-config
  ];

  build-system = [ setuptools ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    libaom
    libde265
    libheif
    x265
  ];

  env = {
    RELEASE_FULL_FLAG = 1;
  };

  dependencies = [ pillow ];

  pythonImportsCheck = [ "pillow_heif" ];

  nativeCheckInputs = [
    opencv4
    numpy
    pytestCheckHook
  ];

  disabledTests = [
    # Time sensitive speed test, not reproducible
    "test_decode_threads"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/bigcat88/pillow_heif/issues/89
    # not reproducible in nixpkgs
    "test_opencv_crash"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # RuntimeError: Encoder plugin generated an error: Unsupported bit depth: Bit depth not supported by x265
    "test_open_heif_compare_non_standard_modes_data"
    "test_open_save_disable_16bit"
    "test_save_bgr_16bit_to_10_12_bit"
    "test_save_bgra_16bit_to_10_12_bit"
    "test_premultiplied_alpha"
    "test_hdr_save"
    "test_I_color_modes_to_10_12_bit"
  ];

  meta = {
    changelog = "https://github.com/bigcat88/pillow_heif/releases/tag/${src.tag}";
    description = "Python library for working with HEIF images and plugin for Pillow";
    homepage = "https://github.com/bigcat88/pillow_heif";
    license = with lib.licenses; [
      bsd3
      lgpl3
    ];
    maintainers = with lib.maintainers; [
      dandellion
      kuflierl
    ];
  };
}
