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

buildPythonPackage rec {
  pname = "pyannoteai-sdk";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pyannoteai_sdk";
    inherit version;
    hash = "sha256-QOA1ABzi3rNR/aDFNXxZhNzBrYL+JEexpi1fTOZYCa0=";
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
}
