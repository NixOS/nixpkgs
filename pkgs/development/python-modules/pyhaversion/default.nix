{ lib
, aiohttp
, aresponses
, awesomeversion
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyhaversion";
  version = "22.02.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-7cBUsTEZ9yVlWsUdKs4YWm647baN09AQJI+7CTORhLc=";
  };

  propagatedBuildInputs = [
    aiohttp
    awesomeversion
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream doesn't set a version for the tagged releases
    substituteInPlace setup.py \
      --replace "main" ${version}
  '';


  pythonImportsCheck = [
    "pyhaversion"
  ];

  meta = with lib; {
    description = "Python module to the newest version number of Home Assistant";
    homepage = "https://github.com/ludeeus/pyhaversion";
    changelog = "https://github.com/ludeeus/pyhaversion/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ makefu ];
  };
}
