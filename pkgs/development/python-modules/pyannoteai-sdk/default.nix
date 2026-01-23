{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyannoteai-sdk";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pyannoteai_sdk";
    inherit (finalAttrs) version;
    hash = "sha256-+9reButUNHN0rPEGmLjJwLzbWS+DOckMWhb6RB6oz50=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [ "pyannoteai.sdk" ];

  # No tests (at least in the Pypi archive)
  doCheck = false;

  meta = {
    description = "Official pyannoteAI Python SDK";
    homepage = "https://pypi.org/project/pyannoteai-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
