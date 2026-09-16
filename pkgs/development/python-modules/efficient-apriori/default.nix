{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "efficient-apriori";
  version = "2.0.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tommyod";
    repo = "Efficient-Apriori";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mWuSEAYxonIv/E703JFYE+ptPXMYKaK3gcRl9xVUic0=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "efficient_apriori"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An efficient Python implementation of the Apriori algorithm";
    homepage = "https://github.com/tommyod/Efficient-Apriori";
    changelog = "https://github.com/tommyod/Efficient-Apriori/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rutwik1221 ];
  };
})
