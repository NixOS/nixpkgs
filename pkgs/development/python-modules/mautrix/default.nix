{ lib, buildPythonPackage, fetchPypi, aiohttp, pythonOlder
, sqlalchemy, ruamel_yaml, CommonMark, lxml
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.10.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7d52d72a9739963b6d39d5e58ef367c00490a90cf7795f23c8b2e2c140c8882";
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
