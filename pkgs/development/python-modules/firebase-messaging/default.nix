{
  lib,
  aiohttp,
  aioresponses,
  async-timeout,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatchling,
  http-ece,
  myst-parser,
  protobuf,
  pytest-asyncio,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  pythonOlder,
  requests-mock,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,
  sphinxHook,
}:

buildPythonPackage rec {
  pname = "firebase-messaging";
  version = "0.4.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "sdb9696";
    repo = "firebase-messaging";
    tag = version;
    hash = "sha256-O1A+hGEhnNcvdXw5QJx+3zYKB+m36N0Ge0XB6cZ6930=";
  };

  outputs = [
    "out"
    "doc"
  ];

  build-system = [
    hatchling
  ];

  nativeBuildInputs = [
    sphinxHook
  ]
  ++ optional-dependencies.docs;

  pythonRelaxDeps = [
    "http-ece"
    "protobuf"
  ];

  dependencies = [
    aiohttp
    cryptography
    http-ece
    protobuf
  ];

  optional-dependencies = {
    docs = [
      myst-parser
      sphinx
      sphinx-autodoc-typehints
      sphinx-rtd-theme
    ];
  };

  pythonImportsCheck = [ "firebase_messaging" ];

  nativeCheckInputs = [
    aioresponses
    async-timeout
    requests-mock
    pytest-asyncio
    pytest-mock
    pytest-socket
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Library to subscribe to GCM/FCM and receive notifications within a python application";
    homepage = "https://github.com/sdb9696/firebase-messaging";
    changelog = "https://github.com/sdb9696/firebase-messaging/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
