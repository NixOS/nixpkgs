{
  lib,
  aiohttp,
  aresponses,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  syrupy,
}:

buildPythonPackage rec {
  pname = "python-homewizard-energy";
  version = "6.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "DCSBL";
    repo = "python-homewizard-energy";
    rev = "refs/tags/v${version}";
    hash = "sha256-CSX2iLjOJRW2dxcE9JhK2A8QlvVUxYE2C6MZFPg370c=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "homewizard_energy" ];

  meta = with lib; {
    description = "Library to communicate with HomeWizard Energy devices";
    homepage = "https://github.com/homewizard/python-homewizard-energy";
    changelog = "https://github.com/homewizard/python-homewizard-energy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
