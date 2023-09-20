{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, absl-py
, cloudpickle
, dm-tree
, jax
, jaxlib
, numpy
, pytestCheckHook
, toolz
, typing-extensions
}:

buildPythonPackage rec {
  pname = "chex";
  version = "0.1.82";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xBq22AaR2Tp1NSPefEyvCDeUYqRZlAf5LVHWo0luiXk=";
  };

  propagatedBuildInputs = [
    absl-py
    jaxlib
    jax
    numpy
    toolz
    typing-extensions
  ];

  pythonImportsCheck = [
    "chex"
  ];

  nativeCheckInputs = [
    cloudpickle
    dm-tree
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Chex is a library of utilities for helping to write reliable JAX code.";
    homepage = "https://github.com/deepmind/chex";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
