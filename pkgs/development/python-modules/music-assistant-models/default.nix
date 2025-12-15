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
  # Must be compatible with music-assistant-client package
  # nixpkgs-update: no auto update
  version = "1.1.70";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "models";
    tag = version;
    hash = "sha256-yJ0MaXbzhvbqdMA1M2l7QC+0ExAHuTU1N4XIkJOj6pg=";
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
    changelog = "https://github.com/music-assistant/models/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
