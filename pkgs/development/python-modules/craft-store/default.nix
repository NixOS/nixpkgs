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
  keyring,
  macaroonbakery,
  overrides,
  pyxdg,
  requests,
  requests-toolbelt,
}:

buildPythonPackage rec {
  pname = "craft-store";
  version = "2.6.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-store";
    rev = "refs/tags/${version}";
    hash = "sha256-VtKOe3IrvGcNWfp1/tg1cO94xtfkP7AbIHh0WTdlfbQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==67.7.2" "setuptools"
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    keyring
    macaroonbakery
    overrides
    pydantic_1
    pyxdg
    requests
    requests-toolbelt
  ];

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
