{ absl-py
, buildPythonPackage
, cloudpickle
, dm-tree
, fetchFromGitHub
, jax
, jaxlib
, lib
, numpy
, pytestCheckHook
, toolz
}:

buildPythonPackage rec {
  pname = "chex";
  version = "0.1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-VolRlLLgKga9S17ByVrYya9VPtu9yiOnvt/WmlE1DOc=";
  };

  propagatedBuildInputs = [
    absl-py
    cloudpickle
    dm-tree
    jax
    numpy
    toolz
  ];

  pythonImportsCheck = [
    "chex"
  ];

  nativeCheckInputs = [
    jaxlib
    pytestCheckHook
  ];

  disabledTests = [
    # See https://github.com/deepmind/chex/issues/204.
    "test_uninspected_checks"

    # These tests started failing at some point after upgrading to 0.1.5
    "test_useful_failure"
    "TreeAssertionsTest"
    "PmapFakeTest"
    "WithDeviceTest"
  ];

  meta = with lib; {
    description = "Chex is a library of utilities for helping to write reliable JAX code.";
    homepage = "https://github.com/deepmind/chex";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
