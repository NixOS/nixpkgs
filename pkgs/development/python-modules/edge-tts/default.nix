{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  # Dependencies
  aiohttp,
  certifi,
  srt,
  tabulate,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "edge-tts";
  version = "7.0.0";
  src = fetchFromGitHub {
    owner = "rany2";
    repo = "edge-tts";
    tag = version;
    hash = "sha256-TwBSEePVFYTvdueunTrFtZd96tp2P/he7+1cmIk2dy8=";
  };

  propagatedBuildInputs = [
    aiohttp
    certifi
    srt
    tabulate
    typing-extensions
  ];

  pythonImportsCheck = [
    "edge_tts"
    "edge_playback"
  ];

  meta = {
    mainProgram = "edge-tts";
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Use Microsoft Edge's online text-to-speech service from Python WITHOUT needing Microsoft Edge or Windows or an API key";
    homepage = "https://pypi.org/project/edge-tts/";
    license = with lib.licenses; [ lgpl3Only ];
  };
}
