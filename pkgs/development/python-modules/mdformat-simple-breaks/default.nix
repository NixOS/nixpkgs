{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mdformat-simple-breaks";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "csala";
    repo = "mdformat-simple-breaks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w0qPxIlCFMvs7p2Lya/ATkQN9wVt8ipsePZgonN/qpc=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    mdformat
  ];

  pythonImportsCheck = [ "mdformat_simple_breaks" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Mdformat plugin to render thematic breaks using three dashes";
    changelog = "https://github.com/csala/mdformat-simple-breaks/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/csala/mdformat-simple-breaks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
})
