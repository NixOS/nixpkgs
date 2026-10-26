{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytest-asyncio,
  pytest9_0CheckHook,
  setuptools,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydeako";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DeakoLights";
    repo = "pydeako";
    tag = finalAttrs.version;
    hash = "sha256-GEYuVKE3DOXJzCqTW2Ngoi6l0e4JvE9lUnZtjrNXTVk=";
  };

  build-system = [ setuptools ];

  dependencies = [ zeroconf ];

  # Module has no tests
  #doCheck = false;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytest9_0CheckHook
  ];

  pythonImportsCheck = [ "pydeako" ];

  meta = {
    description = "Module used to discover and communicate with Deako devices over the network locally";
    homepage = "https://github.com/DeakoLights/pydeako";
    changelog = "https://github.com/DeakoLights/pydeako/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
