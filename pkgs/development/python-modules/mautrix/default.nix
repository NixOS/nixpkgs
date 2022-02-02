{ lib, buildPythonPackage, fetchPypi, aiohttp, pythonOlder
, sqlalchemy, ruamel-yaml, CommonMark, lxml, aiosqlite
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.14.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0GB6LDsZlWmNS3O01nHWu20JCgSptyih7iBjbEFoZaE=";
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
