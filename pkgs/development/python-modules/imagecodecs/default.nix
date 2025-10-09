{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  numpy,
  setuptools,
  pkgs,
  jxrlib,
  lcms2,
  lerc,
  libdeflate,
  libpng,
  libtiff,
  libwebp,
  openjpeg,
  xz,
  zlib,
  zstd,
  pytest,
}:

let
  version = "2025.8.2";
in
buildPythonPackage rec {
  pname = "imagecodecs";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgohlke";
    repo = "imagecodecs";
    tag = "v${version}";
    hash = "sha256-HDyA5SQNZe9G83ARfvD4AAIIos8Oatp+RhnEQTdnRp4=";
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
    pkgs.lz4
    jxrlib
    lcms2
    lerc
    libdeflate
    libpng
    libtiff
    libwebp
    openjpeg
    xz # liblzma
    zlib
    zstd
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
    pytest
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
