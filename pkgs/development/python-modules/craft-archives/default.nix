{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  launchpadlib,
  lazr-restfulclient,
  lazr-uri,
  overrides,
  pydantic,
  python-debian,
  distro,
  setuptools-scm,
  pytest-check,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "craft-archives";
  version = "2.1.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-archives";
    tag = version;
    hash = "sha256-VjGoAsmdYyoU7ngU69HVNauEk2/vbcEz2tMCTmjheF4=";
  };

  postPatch = ''
    substituteInPlace craft_archives/__init__.py \
      --replace-fail "dev" "${version}"

    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==67.7.2" "setuptools"
  '';

  pythonRelaxDeps = [
    "python-debian"
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    distro
    launchpadlib
    lazr-restfulclient
    lazr-uri
    overrides
    pydantic
    python-debian
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
