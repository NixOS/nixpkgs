{
  lib,
  aiohttp,
  aioresponses,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mashumaro,
  orjson,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  webrtc-models,
}:

buildPythonPackage rec {
  pname = "go2rtc-client";
  version = "0.0.1b2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-go2rtc-client";
    rev = "refs/tags/${version}";
    hash = "sha256-q1NDHauYy8C3tlIpt6J0iMj0TNtBv2j9aU/IE5CgBjg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  pythonRelaxDeps = [ "orjson" ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    awesomeversion
    mashumaro
    orjson
    webrtc-models
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "go2rtc_client" ];

  meta = {
    description = "Module for interacting with go2rtc";
    homepage = "https://github.com/home-assistant-libs/python-go2rtc-client";
    changelog = "https://github.com/home-assistant-libs/python-go2rtc-client/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
