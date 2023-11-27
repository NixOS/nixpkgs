{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, twisted
, versioneer
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
      rev = "refs/tags/${version}";
      hash = "sha256-HTj6zbrCrxvh0PeSkeCSOCloTrVGUX6+o57snrKf6PA=";
    };

    nativeBuildInputs = [
      setuptools
      versioneer
    ];

    nativeCheckInputs = [
      twisted
    ];

    # would create dependency loop with twisted
    doCheck = false;

    checkPhase = ''
      trial constantly
    '';

    pythonImportsCheck = [
      "constantly"
    ];

    passthru.tests.constantly = self.overridePythonAttrs { doCheck = true; };

    meta = with lib; {
      description = "Module for symbolic constant support";
      homepage = "https://github.com/twisted/constantly";
      license = licenses.mit;
      maintainers =  with maintainers; [ ];
    };
  };
in
self
