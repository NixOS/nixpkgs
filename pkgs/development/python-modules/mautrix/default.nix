{ lib
, aiohttp
, asyncpg
, attrs
, buildPythonPackage
, CommonMark
, fetchPypi
, lxml
, prometheus_client
, pycryptodome
, python_magic
, python-olm
, pythonOlder
, ruamel-yaml
, sqlalchemy
, unpaddedbase64
, yarl
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.9.3";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pl0juS9bK9Pl+Uk/X375RUq9/w6RQbwL+Jlzj2RN+jU=";
  };

  propagatedBuildInputs = [
    aiohttp
    asyncpg
    attrs
    CommonMark
    lxml
    prometheus_client
    pycryptodome
    python_magic
    python-olm
    ruamel-yaml
    sqlalchemy
    unpaddedbase64
    yarl
  ];

  # no tests available
  doCheck = false;

  pythonImportsCheck = [ "mautrix" ];

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-python";
    description = "Python Matrix framework";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanloutre ma27 ];
  };
}
