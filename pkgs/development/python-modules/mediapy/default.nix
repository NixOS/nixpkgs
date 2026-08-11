{
  lib,
  bash,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  ipython,
  matplotlib,
  numpy,
  pillow,
  absl-py,
  ffmpeg-headless,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mediapy";
  version = "1.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "mediapy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+p88Zc7YuN0P4i1AzTQfQqCFo6Uc6hpDKgoDpdJxMaI=";
  };

  postPatch = ''
    substituteInPlace mediapy_test.py \
      --replace-fail "/bin/bash" "${lib.getExe bash}"
  '';

  build-system = [ flit-core ];

  dependencies = [
    ipython
    matplotlib
    numpy
    pillow
  ];

  nativeCheckInputs = [
    absl-py
    ffmpeg-headless
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: np.float64(148.75258355982479) not less than 51.2
    "test_video_read_write_10bit"
  ];

  pythonImportsCheck = [ "mediapy" ];

  meta = {
    description = "Read/write/show images and videos in an IPython notebook";
    homepage = "https://github.com/google/mediapy";
    changelog = "https://github.com/google/mediapy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
})
