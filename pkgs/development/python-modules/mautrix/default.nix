{ lib, buildPythonPackage, fetchPypi, aiohttp, pythonOlder
, sqlalchemy, ruamel_yaml, CommonMark, lxml, fetchpatch
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.8.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ccaa1691affa5f257e13d61f7c46088ff0affdd782331b01bfdcbd0b3eb5e10e";
  };

  propagatedBuildInputs = [
    aiohttp

    # defined in optional-requirements.txt
    sqlalchemy
    ruamel_yaml
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
    maintainers = with maintainers; [ nyanloutre ma27 ];
  };
}
