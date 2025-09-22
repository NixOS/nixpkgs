{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lark,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rfc3987-syntax";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "willynilly";
    repo = "rfc3987-syntax";
    tag = "v${version}";
    hash = "sha256-6jA/x8KnwBvyW2k384/EB/NJ8BmJJTEHA8YUlQP+1Y4=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    lark
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rfc3987_syntax"
  ];

  meta = {
    changelog = "https://github.com/willynilly/rfc3987-syntax/releases/tag/${src.tag}";
    description = "Helper functions to syntactically validate strings according to RFC 3987";
    homepage = "https://github.com/willynilly/rfc3987-syntax";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
