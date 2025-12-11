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
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "edge-tts";
  version = "7.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rany2";
    repo = "edge-tts";
    tag = version;
    hash = "sha256-JnwfvSa60oEbSEyD6q88Ey6IyGOwVWO0T75VrUKZmos=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    aiohttp
    certifi
    tabulate
    typing-extensions
  ];

  pythonImportsCheck = [ "edge_tts" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Microsoft Edge text-to-speech service WITHOUT Edge, Windows and API keys";
    longDescription = ''
      `edge-tts` is a Python module that allows you to use Microsoft
      Edge's online text-to-speech service from within your Python
      code or using the provided `edge-tts` or `edge-playback`
      command.
    '';
    homepage = "https://github.com/rany2/edge-tts";
    license = with lib.licenses; [
      mit # `src/edge_tts/srt_composer.py` only
      lgpl3Plus # All remaining files
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "edge-tts";
  };
}
