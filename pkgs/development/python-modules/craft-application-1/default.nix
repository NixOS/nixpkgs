{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  craft-cli,
  craft-parts,
  craft-providers,
  pydantic-yaml-0,
  pyyaml,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pytest-check,
  pytest-mock,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "craft-application-1";
  version = "1.2.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-application";
    rev = "refs/tags/${version}";
    hash = "sha256-CXZEWVoE66dlQJp4G8tinufjyaDJaH1Muxz/qd/81oA=";
  };

  postPatch = ''
    substituteInPlace craft_application/__init__.py \
      --replace-fail "dev" "${version}"

    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==67.7.2" "setuptools"
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    craft-cli
    craft-parts
    craft-providers
    pydantic-yaml-0
    pyyaml
  ];

  pythonImportsCheck = [ "craft_application" ];

  nativeCheckInputs = [
    hypothesis
    pytest-check
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests = [ "test_to_yaml_file" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Basis for Canonical craft applications";
    homepage = "https://github.com/canonical/craft-application";
    changelog = "https://github.com/canonical/craft-application/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
