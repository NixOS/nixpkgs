{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  setuptools,
  setuptools-scm,
  pytest-check,
  pytest-httpx,
  pytest-mock,
  pyyaml,
  pytestCheckHook,
  annotated-types,
  httpx,
  jaraco-classes,
  keyring,
  macaroonbakery,
  overrides,
  pydantic,
  pyxdg,
  requests,
  requests-toolbelt,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "craft-store";
  version = "3.3.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-store";
    tag = version;
    hash = "sha256-ige4R5nwlfeSDyhzw0TDQMMIcExIJQuFAFvbNEpreSs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==75.8.0" "setuptools"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [ "httpx" ];

  dependencies = [
    annotated-types
    httpx
    jaraco-classes
    keyring
    macaroonbakery
    overrides
    pydantic
    pyxdg
    requests
    requests-toolbelt
    typing-extensions
  ];

  pythonImportsCheck = [ "craft_store" ];

  nativeCheckInputs = [
    pytest-check
    pytest-httpx
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
