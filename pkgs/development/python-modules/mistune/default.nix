{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mistune";
  version = "3.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "mistune";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7N1Kz2lN6GyDVKUhuGrEkbinV8Vpc4aahal/7KhnIXo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mistune" ];

  meta = {
    changelog = "https://github.com/lepture/mistune/blob/${finalAttrs.src.tag}/docs/changes.rst";
    description = "Sane Markdown parser with useful plugins and renderers";
    homepage = "https://github.com/lepture/mistune";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
