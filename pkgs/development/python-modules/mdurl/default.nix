{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mdurl";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mdurl";
    tag = finalAttrs.version;
    hash = "sha256-wxV8DKeTwKpFTUBuGTQXaVHc0eW1//Y+2V8Kgs85TDM=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdurl" ];

  meta = {
    description = "URL utilities for markdown-it";
    homepage = "https://github.com/executablebooks/mdurl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
