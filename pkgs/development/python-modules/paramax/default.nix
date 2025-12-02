{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  equinox,
  jax,
  jaxtyping,

  # tests
  beartype,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "paramax";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danielward27";
    repo = "paramax";
    tag = "v${version}";
    hash = "sha256-aPbYG3UGR8YbRa2GLLrZvYPxRK5LRGMF8HBTpaZmKds=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    equinox
    jax
    jaxtyping
  ];

  pythonImportsCheck = [ "paramax" ];

  nativeCheckInputs = [
    beartype
    pytestCheckHook
  ];

  meta = {
    description = "Small library of paramaterizations and parameter constraints for PyTrees";
    homepage = "https://github.com/danielward27/paramax";
    changelog = "https://github.com/danielward27/paramax/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
