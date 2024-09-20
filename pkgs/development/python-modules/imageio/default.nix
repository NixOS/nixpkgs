{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  isPyPy,
  substituteAll,

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
  fsspec,
}:

buildPythonPackage rec {
  pname = "imageio";
  version = "2.35.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "imageio";
    repo = "imageio";
    rev = "refs/tags/v${version}";
    hash = "sha256-WeoZE2TPBAhzBBcZNQqoiqvribMCLSZWk/XpdMydvCQ=";
  };

  patches = lib.optionals (!stdenv.isDarwin) [
    (substituteAll {
      src = ./libgl-path.patch;
      libgl = "${libGL.out}/lib/libGL${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

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
    psutil
    pytestCheckHook
  ] ++ fsspec.optional-dependencies.github ++ lib.flatten (builtins.attrValues optional-dependencies);

  pytestFlagsArray = [ "-m 'not needs_internet'" ];

  preCheck = ''
    export IMAGEIO_USERDIR="$TMP"
    export HOME=$TMPDIR
  '';

  disabledTestPaths = [
    # tries to fetch fixtures over the network
    "tests/test_freeimage.py"
    "tests/test_pillow.py"
    "tests/test_spe.py"
    "tests/test_swf.py"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # Segmentation fault
    "test_bayer_write"
    # RuntimeError: No valid H.264 encoder was found with the ffmpeg installation
    "test_writer_file_properly_closed"
    "test_writer_pixelformat_size_verbose"
    "test_writer_ffmpeg_params"
    "test_reverse_read"
  ];

  meta = {
    description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats";
    homepage = "https://imageio.readthedocs.io";
    changelog = "https://github.com/imageio/imageio/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
