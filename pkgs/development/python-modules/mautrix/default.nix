{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, asyncpg
, attrs
, CommonMark
, lxml
, prometheus_client
, pycryptodome
, python-olm
, python_magic
, ruamel_yaml
, sqlalchemy
, unpaddedbase64
, uvloop
, yarl
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.9.2";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nv9nnr02asvkxziibdsb1vjc8crhil41l5a5zxw9h2vb0k2hjgx";
  };

  propagatedBuildInputs = [
    # requirements.txt
    aiohttp
    attrs
    yarl

    # optional-requirements.txt
    CommonMark
    asyncpg
    lxml
    prometheus_client
    pycryptodome
    python-olm
    python_magic
    ruamel_yaml
    sqlalchemy
    unpaddedbase64
    uvloop
  ];

  # no tests available
  doCheck = false;

  pythonImportsCheck = [
    # https://github.com/tulir/mautrix-python#components
    "mautrix"
    "mautrix.api"
    "mautrix.client.api"
    "mautrix.appservice"
    "mautrix.crypto"
    "mautrix.bridge"
    "mautrix.client"
  ];

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-python";
    description = "A Python 3 asyncio Matrix framework.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanloutre ma27 ];
  };
}
