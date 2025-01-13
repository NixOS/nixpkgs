{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  setuptools,
  setuptools-scm,
  pytest-check,
  pytest-mock,
  pydantic,
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
  version = "3.0.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-store";
    rev = "refs/tags/${version}";
    hash = "sha256-l8WnuaMJN4/nZRkWoU6omgbd4hKR2m7YC+YVcvAqzcA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==" "setuptools>="
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    keyring_24
    macaroonbakery
    overrides
    pydantic
    pyxdg
    requests
    requests-toolbelt
  ];

  pythonRelaxDeps = [ "macaroonbakery" ];

  pythonImportsCheck = [ "craft_store" ];

  nativeCheckInputs = [
    pydantic
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
