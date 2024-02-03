{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, aiohttp
, aiohttp-socks
, aioredis
, aresponses
, babel
, certifi
, magic-filter
, pytest-asyncio
, pytest-lazy-fixture
, redis
}:

buildPythonPackage rec {
  pname = "aiogram";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aiogram";
    repo = "aiogram";
    rev = "refs/tags/v${version}";
    hash = "sha256-bWwK761gn7HsR9ObcBDfvQH0fJfTAo0QAcL/HcNdHik=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "aiohttp>=3.8.0,<3.9.0" "aiohttp" \
      --replace "Babel>=2.9.1,<2.10.0" "Babel" \
      --replace "magic-filter>=1.0.9" "magic-filter"
  '';

  propagatedBuildInputs = [
    aiohttp
    babel
    certifi
    magic-filter
  ];

  nativeCheckInputs = [
    aiohttp-socks
    aioredis
    aresponses
    pytest-asyncio
    pytest-lazy-fixture
    pytestCheckHook
    redis
  ];

  # requires network
  disabledTests = [
    "test_download_file_404"
    "test_download_404"
  ];

  pythonImportsCheck = [ "aiogram" ];

  meta = with lib; {
    description = "Modern and fully asynchronous framework for Telegram Bot API";
    homepage = "https://github.com/aiogram/aiogram";
    changelog = "https://github.com/aiogram/aiogram/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
