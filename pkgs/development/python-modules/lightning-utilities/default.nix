{ lib
, buildPythonPackage
, fetchFromGitHub

# build
, setuptools

# runtime
, packaging
, typing-extensions

# tests
, pytest-timeout
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "lightning-utilities";
  version = "0.7.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "utilities";
    rev = "refs/tags/v${version}";
    hash = "sha256-xjE5FsU1d/YcVHlfjtZE0T2LjGvsIOzbGJFU7PMDqdc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    packaging
    typing-extensions
  ];

  pythonImportsCheck = [
    "lightning_utilities"
  ];

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    "lightning_utilities.core.enums.StrEnum"
    "lightning_utilities.core.imports.RequirementCache"
    "lightning_utilities.core.imports.compare_version"
    "lightning_utilities.core.imports.get_dependency_min_version_spec"
  ];

  disabledTestPaths = [
    "docs"

  ];

  meta = with lib; {
    changelog = "https://github.com/Lightning-AI/utilities/releases/tag/v${version}";
    description = "Common Python utilities and GitHub Actions in Lightning Ecosystem";
    homepage = "https://github.com/Lightning-AI/utilities";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
