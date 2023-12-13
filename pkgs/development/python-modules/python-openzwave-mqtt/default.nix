{ lib
, buildPythonPackage
, fetchFromGitHub
, asyncio-mqtt
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-openzwave-mqtt";
  version = "1.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cgarwood";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zqx00dacs59y4gjr4swrn46c7hrp8a1167bcl270333284m8mqm";
  };

  propagatedBuildInputs = [
    asyncio-mqtt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python wrapper for OpenZWave's MQTT daemon";
    homepage = "https://github.com/cgarwood/python-openzwave-mqtt";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
