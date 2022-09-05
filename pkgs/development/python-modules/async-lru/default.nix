{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "async-lru";
  version = "1.0.3";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "async-lru";
    rev = "v${version}";
    hash = "sha256-98ZPFSOFRnymTCfCG9OuajfxXAWyCrByyJEHhpPVPbM=";
  };

  postPatch = ''
    sed -i -e '/^addopts/d' -e '/^filterwarnings/,+2d' setup.cfg
  '';

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pytestFlagsArray = [
    "--asyncio-mode=strict"
  ];

  pythonImportsCheck = [ "async_lru" ];

  meta = with lib; {
    description = "Simple lru cache for asyncio";
    homepage = "https://github.com/wikibusiness/async_lru";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
