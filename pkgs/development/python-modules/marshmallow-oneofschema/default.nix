{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  marshmallow,
  pytestCheckHook,
  flit-core,
}:

buildPythonPackage rec {
  pname = "marshmallow-oneofschema";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "marshmallow-oneofschema";
    tag = version;
    hash = "sha256-Hk36wxZV1hVqIbqDOkEDlqABRKE6s/NyA/yBEXzj/yM=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ marshmallow ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "marshmallow_oneofschema" ];

  meta = {
    description = "Marshmallow library extension that allows schema (de)multiplexing";
    changelog = "https://github.com/marshmallow-code/marshmallow-oneofschema/blob/${version}/CHANGELOG.rst";
    homepage = "https://github.com/marshmallow-code/marshmallow-oneofschema";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ivan-tkatchev ];
  };
}
