{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  rustPlatform,

  # dependencies
  pydantic,

  # optional-dependencies
  fastapi,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "openai-harmony";
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "harmony";
    rev = "v${version}";
    hash = "sha256-CaEldCrjBkjwsVeTzpiAFl/llAnUwJGTlU8Pt8YTV1E=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-HeUK/S9nUDRTVkLf8CPrHfjBbyGZezZGu5P8XkfStVQ=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    pydantic
  ];

  optional-dependencies = {
    demo = [
      fastapi
      uvicorn
    ];
  };

  pythonImportsCheck = [ "openai_harmony" ];

  # Tests require internet access
  doCheck = false;

  meta = {
    description = "Renderer for the harmony response format to be used with gpt-oss";
    homepage = "https://github.com/openai/harmony";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
