{ lib, buildPythonPackage, fetchPypi, aiohttp, pythonOlder
, sqlalchemy, ruamel_yaml, CommonMark, lxml
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.9.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yx9ybpw9ppym8k2ky5pxh3f2icpmk887i8ipwixrcrnml3q136p";
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
