{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, jax
, jaxlib
, jaxtyping
, typing-extensions
, beartype
, optax
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "equinox";
  version = "0.11.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "equinox";
    rev = "refs/tags/v${version}";
    hash = "sha256-la3gPfwQ2pxfZoEikn9uG+Pc3PKafgEgxZ8oVQEm9YM=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    jax
    jaxlib
    jaxtyping
    typing-extensions
  ];

  nativeCheckInputs = [
    beartype
    optax
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "equinox" ];

  meta = with lib; {
    description = "A JAX library based around a simple idea: represent parameterised functions (such as neural networks) as PyTrees";
    changelog = "https://github.com/patrick-kidger/equinox/releases/tag/v${version}";
    homepage = "https://github.com/patrick-kidger/equinox";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
