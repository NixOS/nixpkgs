{
  lib,
  assertpy,
  buildPythonPackage,
  fetchFromGitHub,
  lark,
  pytestCheckHook,
  regex,
  typing-extensions,
  uv-build,
}:

buildPythonPackage rec {
  pname = "pycep-parser";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gruebel";
    repo = "pycep";
    tag = version;
    hash = "sha256-pEFgpLfGcJhUWfs/nG1r7GfIS045cfNh7MVQokluXmM=";
  };

  build-system = [ uv-build ];

  dependencies = [
    lark
    regex
    typing-extensions
  ];

  nativeCheckInputs = [
    assertpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pycep" ];

  meta = {
    description = "Python based Bicep parser";
    homepage = "https://github.com/gruebel/pycep";
    changelog = "https://github.com/gruebel/pycep/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
