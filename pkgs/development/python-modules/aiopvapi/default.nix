{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopvapi";
  version = "1.6.19";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "sander76";
    repo = "aio-powerview-api";
    # no tags on git, no sdist on pypi: https://github.com/sander76/aio-powerview-api/issues/12
    rev = "89711e2a0cb4640eb458767d289dcfa3acafb10f";
    sha256 = "18gbz9rcf183syvxvvhhl62af3b7463rlqxxs49w4m805hkvirdp";
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
