{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  cyclonedds,
  setuptools,
  rich-click,

  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
  pytest-cov-stub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "cyclonedds-python";
  version = "11.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds-python";
    tag = version;
    hash = "sha256-kHAk2cJOMkCcP4Zje28Ew0B1/dHCJsz5KC5SJqXJj2o=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
        --replace-fail "pytest-cov" ""
  '';

  disabledTests = lib.optionals (!pythonOlder "3.13") [
    "test_dynamic_subscribe_complex"
    "test_dynamic_publish_complex"
  ];

  build-system = [ setuptools ];

  buildInputs = [ cyclonedds ];

  dependencies = [ rich-click ];

  env.CYCLONEDDS_HOME = "${cyclonedds.out}";
  env.NIX_CFLAGS_COMPILE = "-Wno-error=discarded-qualifiers";

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    pytest-cov-stub
  ];

  disabled = (!pythonOlder "3.14");

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python binding for Eclipse Cyclone DDS";
    homepage = "https://github.com/eclipse-cyclonedds/cyclonedds-python";
    changelog = "https://github.com/eclipse-cyclonedds/cyclonedds-python/releases/tag/${version}";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ kvik ];
  };
}
