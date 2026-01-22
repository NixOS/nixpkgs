{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  python-dateutil,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "twitchapi";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teekeks";
    repo = "pyTwitchAPI";
    tag = "v${version}";
    hash = "sha256-3kAR/9OS58sDRUiCcQAI7KCCPpnclBNR4SkwDNJs9mo=";
  };

  postPatch = ''
    sed -i "/document_enum/d" twitchAPI/type.py
  '';

  pythonRemoveDeps = [
    "enum-tools"
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    python-dateutil
    typing-extensions
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "twitchAPI.chat"
    "twitchAPI.eventsub"
    "twitchAPI.helper"
    "twitchAPI.oauth"
    "twitchAPI.twitch"
    "twitchAPI.type"
  ];

  meta = {
    changelog = "https://github.com/Teekeks/pyTwitchAPI/blob/${src.tag}/docs/changelog.rst";
    description = "Python implementation of the Twitch Helix API, EventSub and Chat";
    homepage = "https://github.com/Teekeks/pyTwitchAPI";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
    ];
  };
}
