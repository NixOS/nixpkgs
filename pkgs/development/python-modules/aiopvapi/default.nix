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
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "sander76";
    repo = "aio-powerview-api";
    # no tags on git, no sdist on pypi: https://github.com/sander76/aio-powerview-api/issues/12
    rev = "refs/tags/v${version}";
    sha256 = "sha256-QXWne6rTL1RjHemJJEuWX6HB2F5VSe7NJtnCpaew/xI=";
  };

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
