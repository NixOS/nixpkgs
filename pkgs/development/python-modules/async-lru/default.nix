{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "async-lru";
  version = "unstable-2022-02-03";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "async-lru";
    rev = "3574af7691371015c47faf77e0abf8c7b06a3cdc";
    hash = "sha256-EsadpQlRNnebp0UUybzQwzyK4zwFlortutv3VTUsprU=";
  };

  postPatch = ''
    sed -i -e '/^addopts/d' -e '/^filterwarnings/,+2d' setup.cfg
  '';

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # https://github.com/aio-libs/async-lru/issues/341
    "test_alru_cache_deco"
    "test_alru_cache_fn_called"
    "test_close"
  ];

  pythonImportsCheck = [ "async_lru" ];

  meta = with lib; {
    description = "Simple lru cache for asyncio";
    homepage = "https://github.com/wikibusiness/async_lru";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
