{ lib
, aiohttp
, aresponses
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, syrupy
}:

buildPythonPackage rec {
  pname = "python-homewizard-energy";
  version = "4.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "DCSBL";
    repo = "python-homewizard-energy";
    rev = "refs/tags/v${version}";
    hash = "sha256-p7uwodjC+wTGrlKf4i4ZRTPg9Qh9krsmwPpWNdF6J4U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "homewizard_energy"
  ];

  meta = with lib; {
    description = "Library to communicate with HomeWizard Energy devices";
    homepage = "https://github.com/homewizard/python-homewizard-energy";
    changelog = "https://github.com/homewizard/python-homewizard-energy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
