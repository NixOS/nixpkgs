{ lib, buildPythonPackage, fetchPypi, aiohttp, future-fstrings, pythonOlder
, sqlalchemy, ruamel_yaml, CommonMark, lxml, fetchpatch
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a86c6448fb3c0f5e149f3347fbf0cd776431aec16a137a9b45298b6fe5991e42";
  };

  propagatedBuildInputs = [
    aiohttp
    future-fstrings

    # defined in optional-requirements.txt
    sqlalchemy
    ruamel_yaml
    CommonMark
    lxml
  ];

  disabled = pythonOlder "3.5";

  # no tests available
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-python";
    description = "A Python 3 asyncio Matrix framework.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanloutre ma27 ];
  };
}
