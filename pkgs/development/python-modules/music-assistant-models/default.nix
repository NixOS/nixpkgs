{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  mashumaro,
  orjson,

  # tests
  pytestCheckHook,
  pytest-cov-stub,

  # reverse dependencies
  music-assistant-client,
}:

buildPythonPackage rec {
  pname = "music-assistant-models";
  version = "1.1.30"; # Must be compatible with music-assistant-client package
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "models";
    tag = version;
    hash = "sha256-ZLTRHarjVFAk+tYPkgLm192rE+C82vNzqs8PmJhGSeg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "music_assistant_models"
  ];

  passthru.tests = {
    inherit music-assistant-client;
  };

  meta = {
    description = "Models used by Music Assistant (shared by client and server";
    homepage = "https://github.com/music-assistant/models";
    changelog = "https://github.com/music-assistant/models/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
