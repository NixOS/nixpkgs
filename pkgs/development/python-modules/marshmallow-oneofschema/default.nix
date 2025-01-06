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
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "marshmallow-oneofschema";
    tag = version;
    hash = "sha256-HXuyUxU8bT5arpUzmgv7m+X2fNT0qHY8S8Rz6klOGiA=";
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
