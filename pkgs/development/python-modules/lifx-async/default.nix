{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lifx-emulator-core,
  pytest-asyncio,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-retry,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lifx-async";
  version = "5.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Djelibeybi";
    repo = "lifx-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EqB+vCDziZ2JdJQwHzHRB2roqoGu4+Uou10wtj/1yS4=";
  };

  build-system = [ hatchling ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    lifx-emulator-core
    pytest-asyncio
    pytest-benchmark
    pytest-cov-stub
    pytest-retry
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "lifx" ];

  meta = {
    description = "Modern, type-safe, async Python library for controlling LIFX lights";
    homepage = "https://github.com/Djelibeybi/lifx-async/";
    license = lib.licenses.upl;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
