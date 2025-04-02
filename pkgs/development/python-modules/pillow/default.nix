{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,
  pkg-config,

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
  tkinter,
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
  version = "11.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-pillow";
    repo = "pillow";
    tag = version;
    hash = "sha256-gr6S0FTM/VMnqj35E9U5G3BJ203f0XQzgzYCQ81WL/Y=";
  };

  build-system = [ setuptools ];

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
    tkinter
    zlib-ng
  ];

  pypaBuildFlags = [
    # Disable platform guessing, which tries various FHS paths
    "--config=setting=--disable-platform-guessing"
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
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlagsArray = [
    # AssertionError:  average pixel value difference 12.0968 > epsilon 11.5000
    "--deselect=Tests/test_file_avif.py::TestFileAvif::test_read"
    # AssertionError:  average pixel value difference 8.0108 > epsilon 6.0200
    "--deselect=Tests/test_file_avif.py::TestFileAvif::test_write_rgb"
  ];

  disabledTests =
    [
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
    homepage = "https://python-pillow.org";
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
