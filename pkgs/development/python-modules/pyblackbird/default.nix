{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pyserial-asyncio
}:

buildPythonPackage rec {
  pname = "pyblackbird";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "koolsb";
    repo = pname;
    rev = version;
    sha256 = "0m1yd1cb3z8011x7nicxpf091bdcwghcphn0l21c65f71rabzg6s";
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
