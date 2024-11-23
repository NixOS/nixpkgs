{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "multipart";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "defnull";
    repo = "multipart";
    rev = "refs/tags/v${version}";
    hash = "sha256-RaHAV1LapYf0zRW7cxxbe7ysAJ5xB6EvF1bsCbCWS0U=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multipart" ];

  meta = {
    changelog = "https://github.com/defnull/multipart/blob/${src.rev}/README.rst#changelog";
    description = "Parser for multipart/form-data";
    homepage = "https://github.com/defnull/multipart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
