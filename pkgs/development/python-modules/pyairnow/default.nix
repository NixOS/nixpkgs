{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, poetry
, pytest-asyncio
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyairnow";
  version = "1.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "asymworks";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hkpfl8rdwyzqrr1drqlmcw3xpv3pi1jf19h1divspbzwarqxs1c";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytest-aiohttp
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyairnow" ];

  meta = with lib; {
    description = "Python wrapper for EPA AirNow Air Quality API";
    homepage = "https://github.com/asymworks/pyairnow";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
