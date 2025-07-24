{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "twisted";
      repo = "constantly";
      tag = version;
      hash = "sha256-yXPHQP4B83PuRNvDBnRTx/MaPaQxCl1g5Xrle+N/d7I=";
    };

    nativeBuildInputs = [
      setuptools
      versioneer
    ]
    ++ versioneer.optional-dependencies.toml;

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

    meta = with lib; {
      description = "Module for symbolic constant support";
      homepage = "https://github.com/twisted/constantly";
      license = licenses.mit;
      maintainers = [ ];
    };
  };
in
self
