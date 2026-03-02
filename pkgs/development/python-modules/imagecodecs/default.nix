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
  xz,
  zlib,

  # tests
  pytestCheckHook,
}:

let
  version = "2026.1.14";
in
buildPythonPackage rec {
  pname = "imagecodecs";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgohlke";
    repo = "imagecodecs";
    tag = "v${version}";
    hash = "sha256-1q1CF6kIWQEcKRa+ah/MVlSZg8524bn/UbRn3IF6M6I=";
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
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "imagecodecs"
  ];

  meta = {
    description = "Image transformation, compression, and decompression codecs";
    homepage = "https://github.com/cgohlke/imagecodecs";
    changelog = "https://github.com/cgohlke/imagecodecs/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
