{ lib, buildPythonPackage, fetchPypi, aiohttp, pythonOlder
, sqlalchemy, ruamel-yaml, CommonMark, lxml, aiosqlite
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.14.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46a87a8ee9e45e90c72e17ebb75190073e773f0890cfde7b81b0a36e15caec5d";
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

  disabled = pythonOlder "3.7";

  # no tests available
  doCheck = false;

  pythonImportsCheck = [ "mautrix" ];

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-python";
    description = "A Python 3 asyncio Matrix framework.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanloutre ma27 sumnerevans ];
  };
}
