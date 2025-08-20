{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  prompt-toolkit,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "questionary";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tmbo";
    repo = pname;
    tag = version;
    hash = "sha256-HiQsOkG3oK+hnyeFjebnVASxpZhUPGBGz69JvPO43fM=";
  };

  pythonRelaxDeps = [ "prompt_toolkit" ];

  build-system = [ poetry-core ];

  dependencies = [ prompt-toolkit ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ulimit -n 1024
  '';

  disabledTests = [
    # RuntimeError: no running event loop
    "test_blank_line_fix"
  ];

  pythonImportsCheck = [ "questionary" ];

  meta = with lib; {
    description = "Python library to build command line user prompts";
    homepage = "https://github.com/tmbo/questionary";
    changelog = "https://github.com/tmbo/questionary/blob/${src.rev}/docs/pages/changelog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
