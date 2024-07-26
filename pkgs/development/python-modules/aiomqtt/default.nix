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
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sbtinstruments";
    repo = "aiomqtt";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ww4NdCtT04b4tRmarJjB4xmfRBNIQekP8iARAdpmBH0=";
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
    changelog = "https://github.com/sbtinstruments/aiomqtt/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
