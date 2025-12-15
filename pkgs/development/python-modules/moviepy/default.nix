{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  decorator,
  imageio,
  imageio-ffmpeg,
  numpy,
  proglog,
  python-dotenv,
  requests,
  tqdm,

  # optional-dependencies
  matplotlib,
  scikit-image,
  scikit-learn,
  scipy,
  yt-dlp,

  # tests
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "moviepy";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Zulko";
    repo = "moviepy";
    tag = "v${version}";
    hash = "sha256-3vt/EyEOv6yNPgewkgcWcjM0TbQ6IfkR6nytS/WpRyg=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "pillow" ];

  dependencies = [
    decorator
    imageio
    imageio-ffmpeg
    numpy
    proglog
    python-dotenv
    requests
    tqdm
  ];

  optional-dependencies = {
    optionals = [
      matplotlib
      scikit-image
      scikit-learn
      scipy
      yt-dlp
    ];
  };

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  # See https://github.com/NixOS/nixpkgs/issues/381908 and https://github.com/NixOS/nixpkgs/issues/385450.
  pytestFlags = [ "--timeout=600" ];

  pythonImportsCheck = [ "moviepy" ];

  disabledTests = [
    # stalls
    "test_doc_examples"
    # video orientation mismatch, 0 != 180
    "test_PR_529"
    # video orientation [1920, 1080] != [1080, 1920]
    "test_ffmpeg_parse_video_rotation"
    "test_correct_video_rotation"
    # media duration mismatch: assert 230.0 == 30.02
    "test_ffmpeg_parse_infos_decode_file"
    # Failed: DID NOT RAISE <class 'OSError'>
    "test_ffmpeg_resize"
    "test_ffmpeg_stabilize_video"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Failed: Timeout >30.0s
    "test_issue_1682"
  ];

  disabledTestPaths = [
    "tests/test_compositing.py"
    "tests/test_fx.py"
    "tests/test_ImageSequenceClip.py"
    "tests/test_TextClip.py"
    "tests/test_VideoClip.py"
    "tests/test_videotools.py"
  ];

  meta = {
    description = "Video editing with Python";
    homepage = "https://zulko.github.io/moviepy/";
    changelog = "https://github.com/Zulko/moviepy/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
