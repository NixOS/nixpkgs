{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  prompt-toolkit,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "questionary";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tmbo";
    repo = "questionary";
    tag = version;
    hash = "sha256-r7F5y6KD6zonQGtO/9OuCTMTWdkCdd9aqTgKg6eWp08=";
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
