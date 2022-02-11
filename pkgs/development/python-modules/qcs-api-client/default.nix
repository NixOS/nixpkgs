{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, httpx
, iso8601
, poetry-core
, pydantic
, pyjwt
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, pythonOlder
, respx
, retrying
, rfc3339
, toml
}:

buildPythonPackage rec {
  pname = "qcs-api-client";
  version = "0.20.10";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "qcs-api-client-python";
    rev = "v${version}";
    hash = "sha256-pBC8pFrk6iNYPS3/LKaVo+ds2okN56bxzvffEfs6SrU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    attrs
    httpx
    iso8601
    pydantic
    pyjwt
    python-dateutil
    retrying
    rfc3339
    toml
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  patches = [
    # Switch to poetry-core, https://github.com/rigetti/qcs-api-client-python/pull/2
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/rigetti/qcs-api-client-python/commit/32f0b3c7070a65f4edf5b2552648d88435469e44.patch";
      sha256 = "sha256-mOc+Q/5cmwPziojtxeEMWWHSDvqvzZlNRbPtOSeTinQ=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'attrs = "^20.1.0"' 'attrs = "*"' \
      --replace 'httpx = "^0.15.0"' 'httpx = "*"' \
      --replace 'iso8601 = "^0.1.13"' 'iso8601 = "*"' \
      --replace 'pydantic = "^1.7.2"' 'pydantic = "*"' \
      --replace 'pyjwt = "^1.7.1"' 'pyjwt = "*"'
  '';

  disabledTestPaths = [
    # Test is outdated
    "tests/test_client/test_client.py"
  ];

  pythonImportsCheck = [
    "qcs_api_client"
  ];

  meta = with lib; {
    description = "Python library for accessing the Rigetti QCS API";
    homepage = "https://pypi.org/project/qcs-api-client/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
