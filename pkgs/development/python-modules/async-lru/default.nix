{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "async-lru";
  version = "unstable-2020-10-24";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "async-lru";
    rev = "ae252508f9c5aecf9c02ddeb879d06c28dbffc42";
    sha256 = "1gk5qzdvhl2j1mw7xzchbw7bcgk9mzhvqa62nwwmvlbnx88pkwnc";
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
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
