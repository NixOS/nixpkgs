{ lib
, anyio
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, poetry-core
, poetry-dynamic-versioning
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "aiomqtt";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sbtinstruments";
    repo = "aiomqtt";
    rev = "refs/tags/v${version}";
    hash = "sha256-8f3opbvN/hmT6AEMD7Co5n5IqdhP0higbaDGUBWJRzU=";
  };

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = [
    paho-mqtt
    typing-extensions
  ];

  nativeCheckInputs = [
    anyio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiomqtt"
  ];

  pytestFlagsArray = [
    "-m" "'not network'"
  ];

  meta = with lib; {
    description = "The idiomatic asyncio MQTT client, wrapped around paho-mqtt";
    homepage = "https://github.com/sbtinstruments/aiomqtt";
    changelog = "https://github.com/sbtinstruments/aiomqtt/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
