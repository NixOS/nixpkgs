{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, build
, git
, importlib-metadata
, pep517
, pytest-mock
, pytestCheckHook
, setuptools
, tomlkit
, virtualenv
}:

buildPythonPackage rec {
  pname = "poetry-core";
  version = "1.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = version;
    hash = "sha256-h3d0h+WCrrNlfPOlUx6Rj0aG6untD6MiunqvPj4yT+0=";
  };

  # revert update of vendored dependencies to unbreak e.g. zeroconf on x86_64-darwin
  patches = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    (fetchpatch {
      url = "https://github.com/python-poetry/poetry-core/commit/80d7dcdc722dee0e09e5f3303b663003d794832c.patch";
      revert = true;
      hash = "sha256-CPjkNCmuAiowp/kyKqnEfUQNmXK95RMJOIa24nG6xi8=";
    })
    (fetchpatch {
      url = "https://github.com/python-poetry/poetry-core/commit/43fd7fe62676421b3661c96844b5d7cf49b87c07.patch";
      revert = true;
      hash = "sha256-fXq8L23qjLraLeMzB1bwW1jU0eGd236/GHIoYKwOuL0=";
    })
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    build
    git
    pep517
    pytest-mock
    pytestCheckHook
    setuptools
    tomlkit
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

  meta = with lib; {
    changelog = "https://github.com/python-poetry/poetry-core/blob/${src.rev}/CHANGELOG.md";
    description = "Core utilities for Poetry";
    homepage = "https://github.com/python-poetry/poetry-core/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
