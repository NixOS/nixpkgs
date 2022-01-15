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
  version = "4.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64f128212ba0257ae8e47612891a2dae7de2c155c81326257582d565f53778ad";
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
