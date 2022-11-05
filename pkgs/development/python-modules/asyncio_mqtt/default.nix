{ lib
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "asyncio-mqtt";
  version = "0.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sbtinstruments";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-On4N5KPnbwYrJguWwBdrnaNq58ZeGIPYSFzIRBfojpQ=";
  };

  propagatedBuildInputs = [
    paho-mqtt
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  # Module will have tests starting with > 0.13.0
  doCheck = false;

  pythonImportsCheck = [
    "asyncio_mqtt"
  ];

  meta = with lib; {
    description = "Idomatic asyncio wrapper around paho-mqtt";
    homepage = "https://github.com/sbtinstruments/asyncio-mqtt";
    license = licenses.bsd3;
    changelog = "https://github.com/sbtinstruments/asyncio-mqtt/blob/master/CHANGELOG.md";
    maintainers = with maintainers; [ hexa ];
  };
}
