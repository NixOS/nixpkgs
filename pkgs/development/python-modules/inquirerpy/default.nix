{ lib
, buildPythonPackage
, fetchFromGitHub
, furo
, myst-parser
, pfzy
, poetry-core
, prompt-toolkit
, pytestCheckHook
, pythonOlder
, sphinx
, sphinx-autobuild
, sphinx-copybutton
}:

buildPythonPackage rec {
  pname = "inquirerpy";
  version = "0.3.4";
  format = "pyproject";


  src = fetchFromGitHub {
    owner = "kazhala";
    repo = "InquirerPy";
    rev = "refs/tags/${version}";
    hash = "sha256-Ap0xZHEU458tjm6oEN5EtDoSRlnpZ7jvDq1L7fTlQQc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pfzy
    prompt-toolkit
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "InquirerPy"
  ];

  disabledTestPaths = [
    # AttributeError: '_GeneratorContextManager' object has no attribute 'close'
    "tests/prompts/"
    "tests/base/test_simple.py"
    "tests/base/test_complex.py"
    "tests/base/test_list.py"
  ];


  meta = with lib; {
    description = "Python port of Inquirer.js";
    homepage = "https://github.com/kazhala/InquirerPy";
    changelog = "https://github.com/kazhala/InquirerPy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
