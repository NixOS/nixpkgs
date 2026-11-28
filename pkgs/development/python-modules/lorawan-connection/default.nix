{
  lib,
  buildPythonPackage,
  chirpstack-api,
  fetchFromGitHub,
  grpcio,
  hatchling,
  protobuf,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lorawan-connection";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "lorawan-connection";
    tag = finalAttrs.version;
    hash = "sha256-Q3E0YEAf5169+URxVpeicObuY6CNuWnDMrg8F8oYKCw=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  optional-dependencies = {
    chirpstack = [ chirpstack-api ];
    tts = [
      grpcio
      protobuf
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "lorawan_connection" ];

  meta = {
    description = "Backend-neutral LoRaWAN events and device collections for Python";
    homepage = "https://github.com/home-assistant-libs/lorawan-connection";
    changelog = "https://github.com/home-assistant-libs/lorawan-connection/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
