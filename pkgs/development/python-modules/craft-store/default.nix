{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  setuptools,
  setuptools-scm,
  pytest-check,
  pytest-mock,
  pydantic_1,
  pyyaml,
  pytestCheckHook,
  keyring_24,
  macaroonbakery,
  overrides,
  pyxdg,
  requests,
  requests-toolbelt,
}:

buildPythonPackage rec {
  pname = "craft-store";
  version = "2.6.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-store";
    rev = "refs/tags/${version}";
    hash = "sha256-QKfXOgAWMV1mVm32ZP3HQTJmWKm82dEDmy3fo5d67TU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==" "setuptools>="
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    keyring_24
    macaroonbakery
    overrides
    pydantic_1
    pyxdg
    requests
    requests-toolbelt
  ];

  pythonRelaxDeps = [ "macaroonbakery" ];

  pythonImportsCheck = [ "craft_store" ];

  nativeCheckInputs = [
    pydantic_1
    pytest-check
    pytest-mock
    pytestCheckHook
    pyyaml
  ];

  pytestFlagsArray = [ "tests/unit" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interfaces for communicating with Canonical Stores (e.g. Snap Store)";
    homepage = "https://github.com/canonical/craft-store";
    changelog = "https://github.com/canonical/craft-store/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
