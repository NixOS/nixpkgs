{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, fetchpatch
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopvapi";
  version = "unstable-2021-09-27";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "sander76";
    repo = "aio-powerview-api";
    rev = "7b362e28a8ec8c9a53905879d8b519e03fd88e13";
    sha256 = "sha256-7bZLCv9PEJr61vimw39m89w/rha3tQWM8TWMtfd8kjQ=";
  };

  patches = [
    (fetchpatch {
      # Drop loop= kwarg from async_timeout and ClientSession calls
      # https://github.com/sander76/aio-powerview-api/pull/13
      url = "https://github.com/sander76/aio-powerview-api/commit/7be67268050fbbf7652ce5a020d2ff26f34d0b27.patch";
      sha256 = "sha256-7QPwrMP1Sbrayg63YZJcRkVDAqcm6hqh0fuJdrUk5WY=";
    })
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # async_timeout 4.0.0 removes loop, https://github.com/sander76/aio-powerview-api/pull/13
    # Patch doesn't apply due to different line endings
    substituteInPlace aiopvapi/helpers/aiorequest.py \
      --replace ", loop=self.loop)" ")"
  '';

  pythonImportsCheck = [
    "aiopvapi"
  ];

  meta = with lib; {
    description = "Python API for the PowerView API";
    homepage = "https://github.com/sander76/aio-powerview-api";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
