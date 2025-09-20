{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  aiohttp,
  certifi,
  tabulate,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "edge-tts";
  version = "7.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rany2";
    repo = "edge-tts";
    tag = version;
    hash = "sha256-HnMMh3N9mUF8ALRpgx1wjrF2RL2ntRyVOOz4RcJyRMI=";
  };

  build-system = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    certifi
    tabulate
    typing-extensions
  ];

  pythonImportsCheck = [ "edge_tts" ];

  meta = {
    description = "Microsoft Edge text-to-speech service WITHOUT Edge, Windows or API keys";
    longDescription = ''
      `edge-tts` is a Python module that allows you to use Microsoft
      Edge's online text-to-speech service from within your Python
      code or using the provided `edge-tts` or `edge-playback`
      command.
    '';
    homepage = "https://github.com/rany2/edge-tts";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "edge-tts";
  };
}
