{ lib, buildPythonPackage, fetchFromGitHub, twisted }:

let
  self = buildPythonPackage rec {
    pname = "constantly";
    version = "15.1.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "twisted";
      repo = "constantly";
      rev = version;
      hash = "sha256-0RPK5Vy0b6V4ubvm+vfNOAua7Qpa6j+G+QNExFuHgUU=";
    };

    # would create dependency loop with twisted
    doCheck = false;

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
