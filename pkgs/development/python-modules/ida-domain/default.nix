{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  graphviz,
  hatchling,
  idapro,
  nix-update-script,
  packaging,
  pytest-cov-stub,
  pytestCheckHook,
  typing-extensions,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ida-domain";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HexRaysSA";
    repo = "ida-domain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1HprtLuVMwlj7bIYgHD0kQHS/nd7l0fPDEzk0o22M7A=";
  };

  build-system = [ hatchling ];

  dependencies = [
    idapro
    packaging
    typing-extensions
  ];

  nativeCheckInputs = [
    graphviz
    pytest-cov-stub
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # Requires IDE to be installed
  doCheck = false;

  # pythonImportsCheck = [ "ida_domain" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python interface for IDA Pro reverse engineering platform";
    homepage = "https://github.com/HexRaysSA/ida-domain";
    changelog = "https://github.com/HexRaysSA/ida-domain/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
