{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,

  # nativeBuildInputs
  pkgs,
  lcms2,
  openjpeg,

  # buildInputs
  jxrlib,
  lerc,
  libdeflate,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  openjph,
  xz,
  zlib,

  # tests
  pytest-run-parallel,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "imagecodecs";
  version = "2026.10.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgohlke";
    repo = "imagecodecs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PGctU16wv0bisjJ8JwZxfUrIMzU9lR0A+pnvoBl2SY4=";
  };

  build-system = [
    cython
    numpy
    setuptools
  ];

  nativeBuildInputs = [
    pkgs.lz4.dev # lz4 was hidden by python3Packages.lz4
    lcms2.dev
    openjpeg.dev
  ];

  buildInputs = [
    jxrlib
    lcms2
    lerc
    libdeflate
    libjpeg
    libpng
    libtiff
    libwebp
    pkgs.lz4
    openjpeg
    openjph
    xz # liblzma
    zlib
    pkgs.zstd
  ];

  dependencies = [
    numpy
  ];

  prePatch = ''
    substituteInPlace setup.py \
      --replace-fail "/usr/include/openjpeg" "${openjpeg.dev}/include/openjpeg" \
      --replace-fail "/usr/include/jxrlib" "${jxrlib}/include/jxrlib"
  '';

  nativeCheckInputs = [
    pytest-run-parallel
    pytestCheckHook
  ];

  preCheck = ''
    # import from $out
    rm -r imagecodecs
  '';

  disabledTests = [
    # alpha channel not supported by codec
    "jpeg8-rgba"
    "jpeg8-uint8-rgba"
    # lossless mode not supported by legacy JPEG codec
    "test_imread_imwrite"
    # we don't package liblzf
    "test_lzf_exceptions"
  ];

  pythonImportsCheck = [
    "imagecodecs"
  ];

  meta = {
    description = "Image transformation, compression, and decompression codecs";
    homepage = "https://github.com/cgohlke/imagecodecs";
    changelog = "https://github.com/cgohlke/imagecodecs/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
})
