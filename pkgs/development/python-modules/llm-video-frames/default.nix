{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-video-frames,
}:

buildPythonPackage rec {
  pname = "llm-video-frames";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-video-frames";
    tag = version;
    hash = "sha256-brTyBymoFuvSQzsD/4aWzFGCrh3yEmWbpsUNGKT9dcU=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  pythonImportsCheck = [ "llm_video_frames" ];

  passthru.tests = llm.mkPluginTest llm-video-frames;

  meta = {
    description = "LLM plugin to turn a video into individual frames";
    homepage = "https://github.com/simonw/llm-video-frames";
    changelog = "https://github.com/simonw/llm-video-frames/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
