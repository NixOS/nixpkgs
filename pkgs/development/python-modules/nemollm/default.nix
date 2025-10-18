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
    # license isn't visible in pypi currently
    # first ever release had MIT license in the description
    # https://pypi.org/project/nemollm/0.1.0/
    # and has been confirmed as MIT by NVIDIA employees in the Garak discord
    # https://github.com/NixOS/nixpkgs/pull/429835#issuecomment-3155683784
    license = lib.licenses.mit;
    sourceProvenance = [
      # python wheel
      lib.sourceTypes.binaryNativeCode
    ];
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}
