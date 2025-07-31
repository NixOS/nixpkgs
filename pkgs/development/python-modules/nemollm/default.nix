{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,

  requests,
  requests-futures,
  requests-toolbelt,
  tqdm,
}:

buildPythonPackage rec {
  pname = "nemollm";
  version = "0.3.5";
  disabled = pythonOlder "3.6";
  format = "wheel";

  src = fetchPypi {
    inherit pname format version;
    dist = "py3";
    python = "py3";
    hash = "sha256-3jli2C1VfOXz13MUQ2G4l6GBAouOG735SATv+GXurYg=";
  };

  propagatedBuildInputs = [
    requests
    requests-futures
    requests-toolbelt
    tqdm
  ];

  pythonImportsCheck = [ "nemollm" ];

  meta = {
    description = "Python client library for the NeMo LLM API";
    homepage = "https://pypi.org/project/nemollm/";
    license = lib.licenses.unfreeRedistributable; # unknown
    sourceProvenance = with lib.sourceTypes; [
      # python wheel
      lib.sourceTypes.binaryNativeCode
    ];
    maintainers = [ ];
  };
}
