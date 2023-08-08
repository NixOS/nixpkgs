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
  jaxtyping = buildPythonPackage rec {
    pname = "jaxtyping";
    version = "0.2.20";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "google";
      repo = pname;
      rev = "refs/tags/v${version}";
      hash = "sha256-q/KQGV7I7w5p7VP8C9BDUHfPsuCMf2v304qiH+XCzyU=";
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
      check = jaxtyping.overridePythonAttrs { doCheck = true; };
    };

    pythonImportsCheck = [ "jaxtyping" ];

    meta = with lib; {
      description = "Type annotations and runtime checking for JAX arrays and PyTrees";
      homepage = "https://github.com/google/jaxtyping";
      license = licenses.mit;
      maintainers = with maintainers; [ GaetanLepage ];
    };
  };
 in jaxtyping
