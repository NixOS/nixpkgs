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
  version = "1.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tmbo";
    repo = pname;
    rev = version;
    sha256 = "14k24fq2nmk90iv0k7pnmmdhmk8z261397wg52sfcsccyhpdw3i7";
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
    broken = stdenv.isDarwin;
    description = "Python library to build command line user prompts";
    homepage = "https://github.com/tmbo/questionary";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
