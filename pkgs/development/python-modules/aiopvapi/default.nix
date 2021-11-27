{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopvapi";
  version = "1.6.14";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02bl7q166j6rb8av9n1jz11xlwhrzmbkjq70mwr86qaj63pcxrak";
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
