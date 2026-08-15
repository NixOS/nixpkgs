{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "jsonalias";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kevinheavey";
    repo = "jsonalias";
    tag = finalAttrs.version;
    hash = "sha256-1Pb0VpwnAZiv3z+Ur6FS0LV4D9xKvrfAdUtulvr6ACg=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "jsonalias" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Library that defines a Json type alias for Python";
    homepage = "https://github.com/kevinheavey/jsonalias";
    changelog = "https://github.com/kevinheavey/jsonalias/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
