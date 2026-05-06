{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ngxparse";
  version = "0.5.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dvershinin";
    repo = "crossplane";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gXzVjY89YjppneR9Vuce+V+RKIcbIBEvLeAoI54ZegM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "crossplane"
  ];

  meta = {
    description = "Quick and reliable way to convert NGINX configurations into JSON and back";
    homepage = "https://github.com/dvershinin/crossplane";
    changelog = "https://github.com/dvershinin/crossplane/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kaction ];
  };
})
