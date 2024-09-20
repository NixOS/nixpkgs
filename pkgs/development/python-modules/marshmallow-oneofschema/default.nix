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
    rev = "refs/tags/${version}";
    hash = "sha256-HXuyUxU8bT5arpUzmgv7m+X2fNT0qHY8S8Rz6klOGiA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ marshmallow ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "marshmallow_oneofschema" ];

  meta = with lib; {
    description = "Marshmallow library extension that allows schema (de)multiplexing";
    changelog = "https://github.com/marshmallow-code/marshmallow-oneofschema/blob/${version}/CHANGELOG.rst";
    homepage = "https://github.com/marshmallow-code/marshmallow-oneofschema";
    license = licenses.mit;
    maintainers = with maintainers; [ ivan-tkatchev ];
  };
}
