{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  fetchpatch,

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
  fsspec,
  gitMinimal,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
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

  patches = [
    (fetchpatch {
      # https://github.com/imageio/imageio/issues/1139
      # https://github.com/imageio/imageio/pull/1144
      name = "fix-pyav-13-1-compat";
      url = "https://github.com/imageio/imageio/commit/eadfc5906f5c2c3731f56a582536dbc763c3a7a9.patch";
      excludes = [
        "setup.py"
      ];
      hash = "sha256-ycsW1YXtiO3ZecIF1crYaX6vg/nRW4bF4So5uWCVzME=";
    })
  ];

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
    writableTmpDirAsHomeHook
  ]
  ++ fsspec.optional-dependencies.github
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pytestFlags = [ "--test-images=file://${test_images}" ];

  disabledTests = [
    # These should have had `needs_internet` mark applied but don't so far.
    # See https://github.com/imageio/imageio/pull/1142
    "test_read_stream"
    "test_uri_reading"
    "test_trim_filter"
  ];

  disabledTestMarks = [ "needs_internet" ];

  # These tests require the old and vulnerable freeimage binaries; skip.
  disabledTestPaths = [ "tests/test_freeimage.py" ];

  preCheck = ''
    export IMAGEIO_USERDIR=$(mktemp -d)
  '';

  meta = {
    description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats";
    homepage = "https://imageio.readthedocs.io";
    changelog = "https://github.com/imageio/imageio/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
