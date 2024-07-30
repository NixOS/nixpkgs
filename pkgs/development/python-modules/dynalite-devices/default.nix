{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dynalite-devices";
  version = "0.1.48";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ziv1234";
    repo = "python-dynalite-devices";
    rev = "refs/tags/v${version}";
    hash = "sha256-i88aIsRNsToSceQdwfspJg+Y5MO5zC4O6EkyhrYR27g=";
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
  '';

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  pythonImportsCheck = [ "dynalite_devices_lib" ];

  # it would use the erroneous tag v0.47
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Unofficial Dynalite DyNET interface creating devices";
    homepage = "https://github.com/ziv1234/python-dynalite-devices";
    changelog = "https://github.com/ziv1234/python-dynalite-devices/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
