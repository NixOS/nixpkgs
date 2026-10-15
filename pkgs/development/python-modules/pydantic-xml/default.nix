{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  nix-update-script,
  poetry-core,
  pydantic-core,
  pydantic,
  pytestCheckHook,
  xmldiff,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-xml";
  version = "2.21.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dapper91";
    repo = "pydantic-xml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yH42bXLw1CLgIrBnSkd8JQoafev71TnQlLf8Woa2cUY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pydantic
    pydantic-core
  ];

  optional-dependencies = {
    lxml = [ lxml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    xmldiff
  ];

  pythonImportsCheck = [ "pydantic_xml" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python xml for humans";
    homepage = "https://github.com/dapper91/pydantic-xml";
    changelog = "https://github.com/dapper91/pydantic-xml/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ fab ];
  };
})
