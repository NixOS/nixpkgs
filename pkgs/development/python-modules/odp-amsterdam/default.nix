{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  uv-build,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "odp-amsterdam";
  version = "7.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-odp-amsterdam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YUO8L40FjqjdDWLcmDldQ+5hkdVgBQHvAhd1rBTfDLg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.13,<0.13" "uv_build"
  '';

  build-system = [ uv-build ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "odp_amsterdam" ];

  disabledTests = [
    # Tests are outdated
    "test_all_garages"
    "test_single_garage"
    "test_filter_garage_model"
  ];

  meta = {
    description = "Python client for getting garage occupancy in Amsterdam";
    homepage = "https://github.com/klaasnicolaas/python-odp-amsterdam";
    changelog = "https://github.com/klaasnicolaas/python-odp-amsterdam/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
