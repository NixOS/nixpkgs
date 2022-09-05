{ lib
, async-timeout
, buildPythonPackage
, colorlog
, fetchPypi
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyenvisalink";
  version = "4.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CQvomHYNMrf0oQjNCcLyisxIV2+3TOgEPzA9seZYsOs=";
  };

  propagatedBuildInputs = [
    async-timeout
    colorlog
    pyserial
  ];

  # Tests require an Envisalink device
  doCheck = false;

  pythonImportsCheck = [
    "pyenvisalink"
  ];

  meta = with lib; {
    description = "Python interface for Envisalink 2DS/3 Alarm API";
    homepage = "https://github.com/Cinntax/pyenvisalink";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
