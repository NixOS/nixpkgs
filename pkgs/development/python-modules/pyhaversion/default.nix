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
  version = "23.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-HMJqZn0yzN2dP5WTRCbem1Xw8nyH2Hy7oVP4kEKHHAo=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the tagged releases
    substituteInPlace setup.py \
      --replace "main" ${version}
  '';

  propagatedBuildInputs = [
    aiohttp
    awesomeversion
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyhaversion"
  ];

  disabledTests = [
    # Error fetching version information from HaVersionSource.SUPERVISOR Server disconnected
    "test_stable_version"
    "test_etag"
  ];

  meta = with lib; {
    description = "Python module to the newest version number of Home Assistant";
    homepage = "https://github.com/ludeeus/pyhaversion";
    changelog = "https://github.com/ludeeus/pyhaversion/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ makefu ];
  };
}
