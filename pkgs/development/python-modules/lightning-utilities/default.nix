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
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Lightning-AI";
    repo = "utilities";
    rev = "refs/tags/v${version}";
    hash = "sha256-J73sUmX1a7ww+rt1vwBt9P0Xbeoxag6jR0W63xEySCI=";
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

  checkInputs = [
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
