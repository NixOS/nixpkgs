{ lib
, aiohttp
, aresponses
, async-timeout
, awesomeversion
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyhaversion";
  version = "21.10.0";

  # Only 3.8.0 and beyond are supported
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-EvVkewFgkfYL6BjmJ/IWeuCyR+0R0ZxI35i9sxKcqxo=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    awesomeversion
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyhaversion" ];

  meta = with lib; {
    description = "Python module to the newest version number of Home Assistant";
    homepage = "https://github.com/ludeeus/pyhaversion";
    changelog = "https://github.com/ludeeus/pyhaversion/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ makefu ];
  };
}
