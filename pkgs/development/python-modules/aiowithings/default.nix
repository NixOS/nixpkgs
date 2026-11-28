{
  lib,
  aiohttp,
  aiointercept,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mashumaro,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiowithings";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-withings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sBLrabScM8ccWbJLDETeU2ExdttWPLJI9z19Go+l4U8=";
  };

  pythonRelaxDeps = [ "mashumaro" ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
    yarl
  ];

  nativeCheckInputs = [
    aiointercept
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "aiowithings" ];

  pytestFlags = [ "--snapshot-update" ];

  disabledTests = [
    # Tests require network access
    "test_creating_own_session"
    "test_error_codes"
    "test_get_activities"
    "test_get_devices"
    "test_get_goals"
    "test_get_measurement"
    "test_get_new_device"
    "test_get_sleep_summary"
    "test_get_sleep"
    "test_get_workouts"
    "test_list_all_subscriptions"
    "test_list_subscriptions"
    "test_putting_in_own_session"
    "test_revoking"
    "test_subscribing"
    "test_timeout"
    "test_unexpected_server_response"
  ];

  meta = {
    description = "Module to interact with Withings";
    homepage = "https://github.com/joostlek/python-withings";
    changelog = "https://github.com/joostlek/python-withings/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
