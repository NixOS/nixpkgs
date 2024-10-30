{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  build,
  git,
  pytest-mock,
  pytestCheckHook,
  setuptools,
  tomli-w,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "poetry-core";
  version = "1.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = version;
    hash = "sha256-vvwKbzGlvv2LTbXfJxQVM3nUXFGntgJxsku6cbRxCzw=";
  };

  patches = [
    (fetchpatch {
      name = "python-3.12.6.patch";
      url = "https://github.com/python-poetry/poetry-core/commit/bd1ce358dec403c66e62176b11bfad77a51aacfd.patch";
      hash = "sha256-dl2xTsn0nNAGJKNmgNPXlaeJOs1gNfDeQMJnD7EnKB4=";
    })
  ];

  nativeCheckInputs = [
    build
    git
    pytest-mock
    pytestCheckHook
    setuptools
    tomli-w
    virtualenv
  ];

  # Requires git history to work correctly
  disabledTests = [
    "default_with_excluded_data"
    "default_src_with_excluded_data"
  ];

  pythonImportsCheck = [ "poetry.core" ];

  # Allow for package to use pep420's native namespaces
  pythonNamespaces = [ "poetry" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-int-conversion";

  meta = with lib; {
    changelog = "https://github.com/python-poetry/poetry-core/blob/${src.rev}/CHANGELOG.md";
    description = "Core utilities for Poetry";
    homepage = "https://github.com/python-poetry/poetry-core/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
