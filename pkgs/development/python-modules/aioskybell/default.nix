{ lib
, aiofiles
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioskybell";
  version = "22.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-aBT1fDFtq1vasTvCnAXKV2vmZ6LBLZqRCiepv1HDJ+Q=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'version="master",' 'version="${version}",'
  '';

  propagatedBuildInputs = [
    aiohttp
    aiofiles
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioskybell"
  ];

  meta = with lib; {
    description = "API client for Skybell doorbells";
    homepage = "https://github.com/tkdrob/aioskybell";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
