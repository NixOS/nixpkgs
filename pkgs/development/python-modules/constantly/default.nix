{ lib, buildPythonPackage, fetchFromGitHub, twisted, versioneer }:

let
  self = buildPythonPackage rec {
    pname = "constantly";
    version = "23.10.4";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "twisted";
      repo = "constantly";
      rev = version;
      hash = "sha256-HTj6zbrCrxvh0PeSkeCSOCloTrVGUX6+o57snrKf6PA=";
    };

    # would create dependency loop with twisted
    doCheck = false;

    propagatedBuildInputs = [ versioneer ];

    nativeCheckInputs = [ twisted ];

    checkPhase = ''
      trial constantly
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
