{
  lib,
  boolean-py,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "license-expression";
  version = "30.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aboutcode-org";
    repo = "license-expression";
    tag = "v${version}";
    hash = "sha256-Bgkm0nhu/jeqtg3444R2encCtfzd7xnwyCXlZWaYSQ0=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  dependencies = [ boolean-py ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "license_expression" ];

  meta = {
    description = "Utility library to parse, normalize and compare License expressions";
    homepage = "https://github.com/aboutcode-org/license-expression";
    changelog = "https://github.com/aboutcode-org/license-expression/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
