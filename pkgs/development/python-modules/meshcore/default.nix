{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
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
  version = "2.3.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meshcore-dev";
    repo = "meshcore_py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+k3jEiYVKkHPdFYcjaAS/MennI1lFMKE5CuZ+8Kayjc=";
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
