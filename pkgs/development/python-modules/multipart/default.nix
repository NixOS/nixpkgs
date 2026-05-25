{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "multipart";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "defnull";
    repo = "multipart";
    tag = "v${version}";
    hash = "sha256-kLiOK6ovW3ki1CONXVQZCJw/U3K1AoR6rrmJUstwZOw=";
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
