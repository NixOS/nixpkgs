{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bigcat88";
    repo = "pillow_heif";
    tag = "v${version}";
    hash = "sha256-mrEZOSHdUmD2Rtv0tUDFaDSgxrdwjK1fc5PHlNJ2G+k=";
  };

  patches = [
    (fetchpatch {
      # to be removed after next release
      name = "libheif-1.20.1-support.patch";
      url = "https://github.com/bigcat88/pillow_heif/commit/8bca08b1481800ea94ab6ca08b05a889835887ca.patch";
      hash = "sha256-dV1syNzhYgLdKgaFLNV5NJoiU3Z1r8Hookcs/ULlSVI=";
    })
  ];

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

  preCheck = ''
    # https://github.com/bigcat88/pillow_heif/issues/325
    rm tests/images/heif_other/L_xmp_latin1.heic
    rm tests/images/heif/L_xmp.heif
  '';

  disabledTests = [
    # Time based
    "test_decode_threads"
    # Missing EXIF info on WEBP-AVIF variant
    "test_exif_from_pillow"
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
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
