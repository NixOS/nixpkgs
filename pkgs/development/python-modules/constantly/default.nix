{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  versioneer,

  # tests
  twisted,
}:

let
  self = buildPythonPackage rec {
    pname = "constantly";
    version = "23.10.4";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "twisted";
      repo = "constantly";
      tag = version;
      hash = "sha256-yXPHQP4B83PuRNvDBnRTx/MaPaQxCl1g5Xrle+N/d7I=";
    };

    nativeBuildInputs = [
      setuptools
      versioneer
    ];

    # would create dependency loop with twisted
    doCheck = false;

    nativeCheckInputs = [ twisted ];

    checkPhase = ''
      runHook preCheck
      trial constantly
      runHook postCheck
    '';

    pythonImportsCheck = [ "constantly" ];

    passthru.tests.constantly = self.overridePythonAttrs { doCheck = true; };

    meta = {
      description = "Module for symbolic constant support";
      homepage = "https://github.com/twisted/constantly";
      license = lib.licenses.mit;
      maintainers = [ ];
    };
  };
in
self
