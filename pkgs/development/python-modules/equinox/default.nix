{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, jax
, jaxlib
, jaxtyping
, typing-extensions
, beartype
, optax
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "equinox";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "equinox";
    rev = "refs/tags/v${version}";
    hash = "sha256-iYVAbUIZG90kgWger+M+DZmS/kQ3nEPXQFU+90lHgK0=";
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
    pytestCheckHook
  ];

  pythonImportsCheck = [ "equinox" ];

  meta = with lib; {
    description = "A JAX library based around a simple idea: represent parameterised functions (such as neural networks) as PyTrees";
    homepage = "https://github.com/patrick-kidger/equinox";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
