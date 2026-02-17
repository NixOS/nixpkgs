{
  lib,
  attrs,
  buildPythonPackage,
  click,
  commoncode,
  dockerfile-parse,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "container-inspector";
  version = "33.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "container-inspector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uwfqPh4e5zNO0K5rKZ2pxgOkX/KF9pzCsKdYbQuw9MA=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    click
    dockerfile-parse
    commoncode
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "container_inspector" ];

  meta = {
    description = "Suite of analysis utilities and command line tools for container images";
    homepage = "https://github.com/nexB/container-inspector";
    changelog = "https://github.com/nexB/container-inspector/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
