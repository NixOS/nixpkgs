{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools
, versioneer

# tests
, twisted
}:

let
  self = buildPythonPackage rec {
    pname = "constantly";
    version = "23.10.4";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "twisted";
      repo = "constantly";
      rev = version;
      hash = "sha256-HTj6zbrCrxvh0PeSkeCSOCloTrVGUX6+o57snrKf6PA=";
    };

    nativeBuildInputs = [
      setuptools
      versioneer
    ] ++ versioneer.optional-dependencies.toml;

    # would create dependency loop with twisted
    doCheck = false;

    nativeCheckInputs = [
      twisted
    ];

    checkPhase = ''
      runHook preCheck
      trial constantly
      runHook postCheck
    '';

    pythonImportsCheck = [ "constantly" ];

    passthru.tests.constantly = self.overridePythonAttrs { doCheck = true; };

    meta = with lib; {
      homepage = "https://github.com/twisted/constantly";
      description = "symbolic constant support";
      license = licenses.mit;
      maintainers = [ ];
    };
  };
in
self
