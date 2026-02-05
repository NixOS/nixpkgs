{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ply,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonpath-ng";
  version = "1.7.0";
  format = "setuptools";
  # TODO: typo; change to pyproject = true;
  pypropject = true;

  src = fetchFromGitHub {
    owner = "h2non";
    repo = "jsonpath-ng";
    tag = "v${version}";
    hash = "sha256-sfIqEc5SsNQYxK+Ur00fFdVoC0ysOkHrx4Cq/3SpGHw=";
  };

  build-system = [ setuptools ];

  dependencies = [ ply ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsonpath_ng" ];

  meta = {
    description = "JSONPath implementation";
    homepage = "https://github.com/h2non/jsonpath-ng";
    changelog = "https://github.com/h2non/jsonpath-ng/blob/v${version}/History.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "jsonpath_ng";
  };
}
