{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,

  # build-system
  setuptools,

  # native dependencies
  libGL,

  # dependencies
  numpy,
  pillow,

  # optional-dependencies
  astropy,
  av,
  imageio-ffmpeg,
  pillow-heif,
  psutil,
  tifffile,

  # tests
  pytestCheckHook,
  gitMinimal,
  fsspec,
}:

let
  test_images = fetchFromGitHub {
    owner = "imageio";
    repo = "test_images";
    rev = "f676c96b1af7e04bb1eed1e4551e058eb2f14acd";
    leaveDotGit = true;
    hash = "sha256-Kh8DowuhcCT5C04bE5yJa2C+efilLxP0AM31XjnHRf4=";
  };
  libgl = "${libGL.out}/lib/libGL${stdenv.hostPlatform.extensions.sharedLibrary}";
in

buildPythonPackage rec {
  pname = "imageio";
  version = "2.37.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "imageio";
    repo = "imageio";
    tag = "v${version}";
    hash = "sha256-/nxJxZrTYX7F2grafIWwx9SyfR47ZXyaUwPHMEOdKkI=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace tests/test_core.py \
      --replace-fail 'ctypes.util.find_library("GL")' '"${libgl}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pillow
  ];

  optional-dependencies = {
    bsdf = [ ];
    dicom = [ ];
    feisem = [ ];
    ffmpeg = [
      imageio-ffmpeg
      psutil
    ];
    fits = lib.optionals (!isPyPy) [ astropy ];
    freeimage = [ ];
    lytro = [ ];
    numpy = [ ];
    pillow = [ ];
    simpleitk = [ ];
    spe = [ ];
    swf = [ ];
    tifffile = [ tifffile ];
    pyav = [ av ];
    heif = [ pillow-heif ];
  };

  nativeCheckInputs = [
    fsspec
    gitMinimal
    psutil
    pytestCheckHook
  ]
  ++ fsspec.optional-dependencies.github
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pytestFlags = [ "--test-images=file://${test_images}" ];

  # These should have had `needs_internet` mark applied but don't so far.
  # See https://github.com/imageio/imageio/pull/1142
  disabledTests = [
    "test_read_stream"
    "test_uri_reading"
    "test_trim_filter"
  ];

  disabledTestMarks = [ "needs_internet" ];

  # These tests require the old and vulnerable freeimage binaries; skip.
  disabledTestPaths = [ "tests/test_freeimage.py" ];

  preCheck = ''
    export IMAGEIO_USERDIR=$(mktemp -d)
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats";
    homepage = "https://imageio.readthedocs.io";
    changelog = "https://github.com/imageio/imageio/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
