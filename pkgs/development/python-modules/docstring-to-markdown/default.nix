{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "docstring-to-markdown";
  version = "0.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4Jl1XJpxwbxGWxdF4bOerjHyzHCIHtrydklwwk1WGs4=";
  };

  patches = [
    # So pytest-flake8 and pytest-cov won't be needed
    ./remove-coverage-tests.patch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "docstring_to_markdown"
  ];

  meta = with lib; {
    homepage = "https://github.com/python-lsp/docstring-to-markdown";
    description = "On the fly conversion of Python docstrings to markdown";
    changelog = "https://github.com/python-lsp/docstring-to-markdown/releases/tag/v${version}";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
  };
}
