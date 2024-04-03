{ lib
, buildPythonPackage
, fetchFromGitHub
, nix-update-script
, overrides
, setuptools
, pytest-check
, pytest-mock
, pytestCheckHook
, pydantic_1
, pyyaml
}:

buildPythonPackage rec {
  pname = "craft-grammar";
  version = "1.1.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-grammar";
    rev = "refs/tags/${version}";
    hash = "sha256-23KLIO2yHXGe/zb3B8LirJsh+LY9z0c5ZGtF392Kszo";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    overrides
  ];

  pythonImportsCheck = [
    "craft_grammar"
  ];

  nativeCheckInputs = [
    pydantic_1
    pytestCheckHook
    pyyaml
  ];

  pytestFlagsArray = [ "tests/unit" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Advanced grammar for Canonical's craft-parts library";
    homepage = "https://github.com/canonical/craft-grammar";
    changelog = "https://github.com/canonical/craft-grammar/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}

