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
  version = "0.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danielward27";
    repo = "paramax";
    tag = "v${version}";
    hash = "sha256-w6F9XuQEwRfOei6gDAyCHt2HUY7I4H92AlEv1Xddv54=";
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
    description = "A small library of paramaterizations and parameter constraints for PyTrees";
    homepage = "https://github.com/danielward27/paramax";
    changelog = "https://github.com/danielward27/paramax/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
