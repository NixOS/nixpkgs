{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "docstring-to-markdown";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rflkbms94wkcypjcnz30bc4w4iww91h7sqq3j2b6ypzl4g48csa";
  };

  patches = [
    # So pytest-flake8 and pytest-cov won't be needed
    ./remove-coverage-tests.patch
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "docstring_to_markdown"
  ];

  meta = with lib; {
    homepage = "https://github.com/python-lsp/docstring-to-markdown";
    description = "On the fly conversion of Python docstrings to markdown";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
  };
}
