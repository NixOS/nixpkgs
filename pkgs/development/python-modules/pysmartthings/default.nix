{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysmartthings";
  version = "0.7.8";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "andrewsayre";
    repo = pname;
    rev = version;
    hash = "sha256-r+f2+vEXJdQGDlbs/MhraFgEmsAf32PU282blLRLjzc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "aiohttp>=3.8.0,<4.0.0" "aiohttp<=4.0.0"
  '';

  propagatedBuildInputs = [
    aiohttp
  ];

  # https://github.com/andrewsayre/pysmartthings/issues/80
  doCheck = lib.versionOlder aiohttp.version "3.9.0";

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysmartthings"
  ];

  meta = with lib; {
    description = "Python library for interacting with the SmartThings cloud API";
    homepage = "https://github.com/andrewsayre/pysmartthings";
    changelog = "https://github.com/andrewsayre/pysmartthings/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
