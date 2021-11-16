{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "docstring-to-markdown";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XVTlSqqWmvnB5nvjvgGDJmg71KKTq2hHB4//QW7ugvA=";
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
