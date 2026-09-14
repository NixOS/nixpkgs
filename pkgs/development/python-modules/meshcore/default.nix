{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,

  # dependencies
  bleak,
  pycayennelpp,
  pyserial-asyncio-fast,
  pycryptodome,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "meshcore";
  version = "2.3.7";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-JnEH4JqW99DWP0vbFALQM6ckuq3Zyb7Pm3GkWBcPYLs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bleak
    pycayennelpp
    pyserial-asyncio-fast
    pycryptodome
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "meshcore" ];

  meta = {
    description = "Python library for communicating with meshcore companion radios";
    homepage = "https://github.com/meshcore-dev/meshcore_py";
    changelog = "https://github.com/meshcore-dev/meshcore_py/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ haylin ];
  };
})
