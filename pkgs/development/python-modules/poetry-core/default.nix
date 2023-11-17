{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, build
, git
, pytest-mock
, pytestCheckHook
, setuptools
, tomli-w
, virtualenv
}:

buildPythonPackage rec {
  pname = "poetry-core";
  version = "1.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = version;
    hash = "sha256-OfY2zc+5CgOrgbiPVnvMdT4h1S7Aek8S7iThl6azmsk=";
  };

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

  pythonImportsCheck = [
    "poetry.core"
  ];

  # Allow for package to use pep420's native namespaces
  pythonNamespaces = [
    "poetry"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-int-conversion";

  meta = with lib; {
    changelog = "https://github.com/python-poetry/poetry-core/blob/${src.rev}/CHANGELOG.md";
    description = "Core utilities for Poetry";
    homepage = "https://github.com/python-poetry/poetry-core/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
