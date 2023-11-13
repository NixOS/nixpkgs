{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, jax
, jaxlib
, jaxtyping
, typing-extensions
, beartype
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "equinox";
  version = "0.10.11";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-JffuPplIROPog29FBsWH9cQHSkrFKuXjaTjjEwIqW/0=";
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
