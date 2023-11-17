{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, isPyPy
, substituteAll

# build-system
, setuptools

# native dependencies
, libGL

# dependencies
, numpy
, pillow

# optional-dependencies
, astropy
, av
, imageio-ffmpeg
, pillow-heif
, psutil
, tifffile

# tests
, pytestCheckHook
, fsspec
}:

buildPythonPackage rec {
  pname = "imageio";
  version = "2.32.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5CWtNsYFMI2eptk+2nsJh5JgWbi4YiDhQqWZp5dRKN0=";
  };

  patches = [
    # pillow 10.1.0 compat
    (fetchpatch {
      name = "imageio-pillow-10.1.0-compat.patch";
      url = "https://github.com/imageio/imageio/commit/f58379c1ae7fbd1da8689937b39e499e2d225740.patch";
      hash = "sha256-jPSl/EUe69Dizkv8CqWpnm+TDPtF3VX2DkHOCEuYTLA=";
    })
  ] ++ lib.optionals (!stdenv.isDarwin) [
    (substituteAll {
      src = ./libgl-path.patch;
      libgl = "${libGL.out}/lib/libGL${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    pillow
  ];

  passthru.optional-dependencies = {
    bsdf = [];
    dicom = [];
    feisem = [];
    ffmpeg = [
      imageio-ffmpeg
      psutil
    ];
    fits = lib.optionals (!isPyPy) [
      astropy
    ];
    freeimage = [];
    lytro = [];
    numpy = [];
    pillow = [];
    simpleitk = [];
    spe = [];
    swf = [];
    tifffile = [
      tifffile
    ];
    pyav = [
      av
    ];
    heif = [
      pillow-heif
    ];
  };

  nativeCheckInputs = [
    fsspec
    psutil
    pytestCheckHook
  ]
  ++ fsspec.optional-dependencies.github
  ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    "-m 'not needs_internet'"
  ];

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

  meta = with lib; {
    description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats";
    homepage = "https://imageio.readthedocs.io";
    changelog = "https://github.com/imageio/imageio/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ Luflosi ];
  };
}
