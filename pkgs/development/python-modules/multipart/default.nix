{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "multipart";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "defnull";
    repo = "multipart";
    tag = "v${version}";
    hash = "sha256-6vlyoi4nayZOKyfO4jbKNzUy7G6K7mySYzkqfp+45O4=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multipart" ];

  meta = {
    changelog = "https://github.com/defnull/multipart/blob/${src.tag}/CHANGELOG.rst";
    description = "Parser for multipart/form-data";
    homepage = "https://github.com/defnull/multipart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
