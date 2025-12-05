{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,
  pkg-config,
  pybind11,

  # native dependencies
  freetype,
  lcms2,
  libavif,
  libimagequant,
  libjpeg,
  libraqm,
  libtiff,
  libwebp,
  libxcb,
  openjpeg,
  zlib-ng,

  # optional dependencies
  defusedxml,
  olefile,
  typing-extensions,

  # tests
  numpy,
  pytest-cov-stub,
  pytestCheckHook,

  # for passthru.tests
  imageio,
  matplotlib,
  pilkit,
  pydicom,
  reportlab,
  sage,
}:

buildPythonPackage rec {
  pname = "pillow";
  version = "12.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-pillow";
    repo = "pillow";
    tag = version;
    hash = "sha256-58mjwHErEZPkkGBVZznkkMQN5Zo4ZBBiXnhqVp1F81g=";
  };

  build-system = [
    setuptools
    pybind11
  ];

  nativeBuildInputs = [ pkg-config ];

  # https://pillow.readthedocs.io/en/latest/installation/building-from-source.html#building-from-source
  buildInputs = [
    freetype
    lcms2
    libavif
    libimagequant
    libjpeg
    libraqm
    libtiff
    libwebp
    libxcb
    openjpeg
    zlib-ng
  ];

  pypaBuildFlags = [
    # Disable platform guessing, which tries various FHS paths
    "--config-setting=--disable-platform-guessing"
  ];

  preConfigure =
    let
      getLibAndInclude = pkg: ''"${pkg.out}/lib", "${lib.getDev pkg}/include"'';
    in
    ''
      # The build process fails to find the pkg-config files for these dependencies
      substituteInPlace setup.py \
        --replace-fail 'AVIF_ROOT = None' 'AVIF_ROOT = ${getLibAndInclude libavif}' \
        --replace-fail 'IMAGEQUANT_ROOT = None' 'IMAGEQUANT_ROOT = ${getLibAndInclude libimagequant}' \
        --replace-fail 'JPEG2K_ROOT = None' 'JPEG2K_ROOT = ${getLibAndInclude openjpeg}'

      # Build with X11 support
      export LDFLAGS="$LDFLAGS -L${libxcb}/lib"
      export CFLAGS="$CFLAGS -I${libxcb.dev}/include"
    '';

  optional-dependencies = {
    fpx = [ olefile ];
    mic = [ olefile ];
    typing = lib.optionals (pythonOlder "3.10") [ typing-extensions ];
    xmp = [ defusedxml ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    numpy
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # Code quality mismathch 9 vs 10
    "test_pyroma"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Disable darwin tests which require executables: `iconutil` and `screencapture`
    "test_grab"
    "test_grabclipboard"
    "test_save"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Crashes the interpreter
    "Tests/test_imagetk.py"

    # Checks for very precise color values on what's basically white
    "Tests/test_file_avif.py::TestFileAvif::test_background_from_gif"
  ];

  passthru.tests = {
    inherit
      imageio
      matplotlib
      pilkit
      pydicom
      reportlab
      sage
      ;
  };

  meta = with lib; {
    homepage = "https://python-pillow.github.io/";
    changelog = "https://pillow.readthedocs.io/en/stable/releasenotes/${version}.html";
    description = "Friendly PIL fork (Python Imaging Library)";
    longDescription = ''
      The Python Imaging Library (PIL) adds image processing
      capabilities to your Python interpreter.  This library
      supports many file formats, and provides powerful image
      processing and graphics capabilities.
    '';
    license = licenses.mit-cmu;
    maintainers = with maintainers; [ hexa ];
  };

}
