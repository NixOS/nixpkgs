{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, pythonOlder
, sqlalchemy
, ruamel-yaml
, CommonMark
, lxml
, aiosqlite
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.18.8";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DRJhqHpeGbDzqhym6z9wCmzTz3VpnwJMdDKFT5vMVUE=";
  };

  propagatedBuildInputs = [
    aiohttp

    # defined in optional-requirements.txt
    sqlalchemy
    aiosqlite
    ruamel-yaml
    CommonMark
    lxml
  ];

  # no tests available
  doCheck = false;

  pythonImportsCheck = [
    "mautrix"
  ];

  meta = with lib; {
    description = "Asyncio Matrix framework";
    homepage = "https://github.com/tulir/mautrix-python";
    changelog = "https://github.com/mautrix/python/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanloutre ma27 sumnerevans ];
  };
}
