{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  tqdm,
  ffmpeg-progress-yield,
  colorlog,
  mutagen,
  ffmpeg,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "ffmpeg-normalize";
  version = "1.37.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slhck";
    repo = "ffmpeg-normalize";
    tag = "v${version}";
    hash = "sha256-KhkGBsuLMNtbo51M1ljIjn6OWSGQasEg2XoS1f1xpoo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.14,<0.9.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    tqdm
    ffmpeg-progress-yield
    colorlog
    mutagen
  ];

  pythonRelaxDeps = [ "colorlog" ];

  nativeCheckInputs = [
    pytestCheckHook
    ffmpeg
  ];

  # Tests require network access and specific ffmpeg features
  doCheck = false;

  pythonImportsCheck = [ "ffmpeg_normalize" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Normalize audio via ffmpeg";
    homepage = "https://github.com/slhck/ffmpeg-normalize";
    changelog = "https://github.com/slhck/ffmpeg-normalize/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "ffmpeg-normalize";
    maintainers = with lib.maintainers; [ sophronesis ];
  };
}
