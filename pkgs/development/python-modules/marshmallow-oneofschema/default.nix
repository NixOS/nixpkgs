{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  marshmallow,
  pytestCheckHook,
  pythonOlder,
  flit-core,
}:

buildPythonPackage rec {
  pname = "marshmallow-oneofschema";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

<<<<<<< HEAD
  meta = {
    description = "Marshmallow library extension that allows schema (de)multiplexing";
    changelog = "https://github.com/marshmallow-code/marshmallow-oneofschema/blob/${version}/CHANGELOG.rst";
    homepage = "https://github.com/marshmallow-code/marshmallow-oneofschema";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ivan-tkatchev ];
=======
  meta = with lib; {
    description = "Marshmallow library extension that allows schema (de)multiplexing";
    changelog = "https://github.com/marshmallow-code/marshmallow-oneofschema/blob/${version}/CHANGELOG.rst";
    homepage = "https://github.com/marshmallow-code/marshmallow-oneofschema";
    license = licenses.mit;
    maintainers = with maintainers; [ ivan-tkatchev ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
