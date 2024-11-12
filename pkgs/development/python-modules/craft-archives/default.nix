{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  launchpadlib,
  lazr-restfulclient,
  overrides,
  pydantic,
  setuptools,
  setuptools-scm,
  tabulate,
  pytest-check,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "craft-archives";
  version = "2.0.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-archives";
    rev = "refs/tags/${version}";
    hash = "sha256-BrKyOdfbwt9qU5Bt/kX/+GgxH7LCFmmFg4mevBWVp2I=";
  };

  postPatch = ''
    substituteInPlace craft_archives/__init__.py \
      --replace-fail "dev" "${version}"

    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==67.7.2" "setuptools"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    launchpadlib
    lazr-restfulclient
    overrides
    pydantic
    tabulate
  ];

  pythonImportsCheck = [ "craft_archives" ];

  nativeCheckInputs = [
    pytest-check
    pytest-mock
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library for handling archives/repositories in Canonical craft applications";
    homepage = "https://github.com/canonical/craft-archives";
    changelog = "https://github.com/canonical/craft-archives/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
