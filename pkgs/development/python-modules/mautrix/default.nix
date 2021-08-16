{ lib, buildPythonPackage, fetchPypi, aiohttp, pythonOlder
, sqlalchemy, ruamel_yaml, CommonMark, lxml
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-D4lVTOiHdsMzqw/1kpNdvk3GX1y/stUaCCplXPu2/88=";
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
