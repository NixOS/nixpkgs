{ lib, buildPythonPackage, fetchPypi, aiohttp, pythonOlder
, sqlalchemy, ruamel-yaml, CommonMark, lxml
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.12.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7095cc4e5aa85043416fbfc5ca3e03c46800dcebfe3ac1d502e520197cea1ee";
  };

  propagatedBuildInputs = [
    aiohttp

    # defined in optional-requirements.txt
    sqlalchemy
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
