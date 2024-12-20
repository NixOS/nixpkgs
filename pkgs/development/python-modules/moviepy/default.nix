{
  lib,
  buildPythonPackage,
  decorator,
  fetchFromGitHub,
  imageio,
  imageio-ffmpeg,
  matplotlib,
  numpy,
  proglog,
  pytestCheckHook,
  pythonOlder,
  requests,
  scikit-image,
  scikit-learn,
  scipy,
  setuptools,
  tqdm,
  yt-dlp,
}:

buildPythonPackage rec {
  pname = "moviepy";
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Zulko";
    repo = "moviepy";
    rev = "refs/tags/v${version}";
    hash = "sha256-l7AwzAKSaEV+pPbltKgwllK6X54oruU2w0AvoCsrESE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "decorator>=4.0.2,<5.0" "decorator>=4.0.2,<6.0"
  '';

  build-system = [ setuptools ];

  dependencies = [
    decorator
    imageio
    imageio-ffmpeg
    numpy
    proglog
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
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "moviepy" ];

  disabledTests = [
    "test_cuts1"
    "test_issue"
    "test_PR"
    "test_setup"
    "test_subtitles"
    "test_sys_write_flush"
    # media duration mismatch: assert 2.9 == 3.0
    "test_ffmpeg_parse_infos"
  ];

  disabledTestPaths = [
    "tests/test_compositing.py"
    "tests/test_fx.py"
    "tests/test_ImageSequenceClip.py"
    "tests/test_resourcerelease.py"
    "tests/test_resourcereleasedemo.py"
    "tests/test_TextClip.py"
    "tests/test_VideoClip.py"
    "tests/test_Videos.py"
    "tests/test_videotools.py"
  ];

  meta = with lib; {
    description = "Video editing with Python";
    homepage = "https://zulko.github.io/moviepy/";
    changelog = "https://github.com/Zulko/moviepy/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
