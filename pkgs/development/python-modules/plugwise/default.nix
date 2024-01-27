 { lib
, aiohttp
, async-timeout
, buildPythonPackage
, crcmod
, defusedxml
, fetchFromGitHub
, freezegun
, jsonpickle
, munch
, pyserial
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, pythonOlder
, semver
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "plugwise";
  version = "0.36.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "plugwise";
    repo = "python-plugwise";
    rev = "refs/tags/v${version}";
    hash = "sha256-LhwrrGle9B2zGhlgPLH+uB6ZiWbNPm1GbPXuUh8RLyo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools~=68.0" "setuptools" \
      --replace "wheel~=0.40.0" "wheel"
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    crcmod
    defusedxml
    munch
    pyserial
    python-dateutil
    semver
  ];

  nativeCheckInputs = [
    freezegun
    jsonpickle
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "plugwise"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python module for Plugwise Smiles, Stretch and USB stick";
    homepage = "https://github.com/plugwise/python-plugwise";
    changelog = "https://github.com/plugwise/python-plugwise/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
