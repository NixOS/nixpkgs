{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, prompt-toolkit
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "questionary";
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tmbo";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-JY0kXomgiGtOrsXfRf0756dTPVgud91teh+jW+kFNdk=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "prompt_toolkit"
  ];

  propagatedBuildInputs = [
    prompt-toolkit
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = lib.optionalString stdenv.isDarwin ''
    ulimit -n 1024
  '';

  disabledTests = [
    # RuntimeError: no running event loop
    "test_blank_line_fix"
  ];

  pythonImportsCheck = [
    "questionary"
  ];

  meta = with lib; {
    description = "Python library to build command line user prompts";
    homepage = "https://github.com/tmbo/questionary";
    changelog = "https://github.com/tmbo/questionary/blob/${src.rev}/docs/pages/changelog.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
