{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "multipart";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "defnull";
    repo = "multipart";
    rev = "refs/tags/v${version}";
    hash = "sha256-mQMv5atWrWpwyY9YYjaRYNDm5AfW54drPSKL7qiae+I=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multipart" ];

  meta = {
    changelog = "https://github.com/defnull/multipart/blob/${src.rev}/CHANGELOG.rst";
    description = "Parser for multipart/form-data";
    homepage = "https://github.com/defnull/multipart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
