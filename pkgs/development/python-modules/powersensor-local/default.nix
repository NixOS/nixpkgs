{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "powersensor-local";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DiUS";
    repo = "python-powersensor_local";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rd9xGq+lo/PoxbXOgPSJL2weWj1SWcpXi6OG8SchZ+w=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    zeroconf = [ zeroconf ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.zeroconf;

  pythonImportsCheck = [ "powersensor_local" ];

  meta = {
    description = "Network-local interface for Powersensor devices";
    homepage = "https://github.com/DiUS/python-powersensor_local";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
