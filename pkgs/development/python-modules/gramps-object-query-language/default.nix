{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gramps,
  pytestCheckHook,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gramps-object-query-language";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dsblank";
    repo = "gramps-object-query-language";
    tag = finalAttrs.version;
    hash = "sha256-/zvy93yFsz3buYwQ6SKXWPKH77o1q8k1Zg448GOIdWs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    gramps
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "gramps_object_query_language" ];

  meta = {
    description = "Gramps query language and compiler to SQL for gramps-web-api";
    homepage = "https://github.com/dsblank/gramps-object-query-language";
    changelog = "https://github.com/dsblank/gramps-object-query-language/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
