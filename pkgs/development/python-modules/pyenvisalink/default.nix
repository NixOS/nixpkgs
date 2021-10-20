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
  version = "4.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h30gmmynihmjkd107skk2gpi210b6gfdahwqmydyj5isxrvzmq2";
  };

  propagatedBuildInputs = [
    async-timeout
    colorlog
    pyserial
  ];

  # Tests require an Envisalink device
  doCheck = false;
  pythonImportsCheck = [ "pyenvisalink" ];

  meta = with lib; {
    description = "Python interface for Envisalink 2DS/3 Alarm API";
    homepage = "https://github.com/Cinntax/pyenvisalink";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
