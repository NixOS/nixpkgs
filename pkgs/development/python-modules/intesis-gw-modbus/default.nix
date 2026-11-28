{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  modbus-connection,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "intesis-gw-modbus";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TimoPtr";
    repo = "intesis-gw-modbus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HaNop9NDsEn0FjpT+Skff7KzOaw3ZtSyJBN8pCURMY0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=84.2.1" "setuptools" \
      --replace-fail "setuptools-scm>=10.3.4" "setuptools-scm"
  '';

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ modbus-connection ] ++ modbus-connection.optional-dependencies.tmodbus;

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "intesis_gw_modbus" ];

  meta = {
    description = "Python library for Intesis INMBS Modbus gateways";
    homepage = "https://github.com/TimoPtr/intesis-gw-modbus";
    changelog = "https://github.com/TimoPtr/intesis-gw-modbus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
