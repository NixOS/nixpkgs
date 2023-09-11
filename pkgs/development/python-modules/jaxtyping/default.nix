{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, numpy
, typeguard
, typing-extensions
, cloudpickle
, equinox
, jax
, jaxlib
, torch
, pytestCheckHook
}:

let
  self = buildPythonPackage rec {
    pname = "jaxtyping";
    version = "0.2.21";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "google";
      repo = "jaxtyping";
      rev = "refs/tags/v${version}";
      hash = "sha256-BacfFcrzXeS6LemU7P6oCZJGB/Zzq09kEPuz2rTIyfI=";
    };

    nativeBuildInputs = [
      hatchling
    ];

    propagatedBuildInputs = [
      numpy
      typeguard
      typing-extensions
    ];

    nativeCheckInputs = [
      cloudpickle
      equinox
      jax
      jaxlib
      pytestCheckHook
      torch
    ];

    doCheck = false;

    # Enable tests via passthru to avoid cyclic dependency with equinox.
    passthru.tests = {
      check = self.overridePythonAttrs { doCheck = true; };
    };

    pythonImportsCheck = [ "jaxtyping" ];

    meta = with lib; {
      description = "Type annotations and runtime checking for JAX arrays and PyTrees";
      homepage = "https://github.com/google/jaxtyping";
      license = licenses.mit;
      maintainers = with maintainers; [ GaetanLepage ];
    };
  };
 in self
