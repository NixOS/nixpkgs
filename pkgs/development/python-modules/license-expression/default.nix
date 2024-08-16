{
  lib,
  boolean-py,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "license-expression";
  version = "30.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "license-expression";
    rev = "refs/tags/v${version}";
    hash = "sha256-+hINYDfUrNsCmXOIa4XO/ML1fJoB8/n6iQ4UGdw5ClE=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  dependencies = [ boolean-py ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "license_expression" ];

  meta = with lib; {
    description = "Utility library to parse, normalize and compare License expressions";
    homepage = "https://github.com/nexB/license-expression";
    changelog = "https://github.com/nexB/license-expression/blob/v${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
