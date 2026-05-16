{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  lark,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "beancount-parser";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beancount-parser";
    tag = finalAttrs.version;
    hash = "sha256-8YcrsLdSRTixKXU/IM821kNcBo0jB/8DXA1/KiedsBY=";
  };

  buildInputs = [ poetry-core ];

  propagatedBuildInputs = [ lark ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "beancount_parser" ];

  meta = {
    description = "Standalone Lark based Beancount syntax parser";
    homepage = "https://github.com/LaunchPlatform/beancount-parser/";
    changelog = "https://github.com/LaunchPlatform/beancount-parser/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
