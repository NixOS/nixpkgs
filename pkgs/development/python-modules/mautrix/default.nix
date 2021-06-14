{ lib, buildPythonPackage, fetchPypi, aiohttp, pythonOlder
, sqlalchemy, ruamel_yaml, CommonMark, lxml
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FDXddvSikrLDNP8Llyv2tqAGwNAo8B7b1NPmVfyzq3s=";
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
