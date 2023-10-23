{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, substituteAll
, imageio-ffmpeg
, numpy
, pillow
, psutil
, pytestCheckHook
, tifffile
, fsspec
, libGL
}:

buildPythonPackage rec {
  pname = "imageio";
  version = "2.31.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dMaoMtgbetWoqAl23qWO4DPT4rmaVJkMvXibTLCzFGE=";
  };

  patches = lib.optionals (!stdenv.isDarwin) [
    (substituteAll {
      src = ./libgl-path.patch;
      libgl = "${libGL.out}/lib/libGL${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  propagatedBuildInputs = [
    imageio-ffmpeg
    numpy
    pillow
  ];

  nativeCheckInputs = [
    fsspec
    psutil
    pytestCheckHook
    tifffile
  ];

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
