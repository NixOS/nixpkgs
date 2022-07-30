{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, prompt-toolkit
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "questionary";
  version = "unstable-2022-07-27";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tmbo";
    repo = pname;
    rev = "848b040c5b7086ffe75bd92c656e15e94d905146";
    hash = "sha256-W0d1Uoy5JdN3BFfeyk1GG0HBzmgKoBApaGad0UykZaY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    prompt-toolkit
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # TypeError: <lambda>() missing 1 required...
    "test_print_with_style"
  ];

  pythonImportsCheck = [
    "questionary"
  ];

  meta = with lib; {
    description = "Python library to build command line user prompts";
    homepage = "https://github.com/tmbo/questionary";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
