{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pyserial-asyncio
}:

buildPythonPackage rec {
  pname = "pyblackbird";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "koolsb";
    repo = pname;
    rev = version;
    sha256 = "sha256-+ehzrr+RrwFKOOuxBq3+mwnuMPxZFV4QTZG1IRgsbLc=";
  };

  propagatedBuildInputs = [
    pyserial
    pyserial-asyncio
  ];

  # Test setup try to create a serial port
  doCheck = false;
  pythonImportsCheck = [ "pyblackbird" ];

  meta = with lib; {
    description = "Python implementation for Monoprice Blackbird units";
    homepage = "https://github.com/koolsb/pyblackbird";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
