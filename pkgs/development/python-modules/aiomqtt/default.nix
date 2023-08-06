{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch

# build-system
, poetry-core
, poetry-dynamic-versioning

# dependencies
, paho-mqtt
, typing-extensions

# tests
, anyio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiomqtt";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sbtinstruments";
    repo = "aiomqtt";
    rev = "v${version}";
    hash = "sha256-ct4KIGxiC5m0yrid0tOa/snO9oErxbqhLLH9kD69aEQ=";
  };

  patches = [
    (fetchpatch {
      # adds test marker for network access
      url = "https://github.com/sbtinstruments/aiomqtt/commit/225c1bfc99bc6ff908bd03c1115963e43ab8a9e6.patch";
      hash = "sha256-UMEwCoX2mWBA7+p+JujkH5fc9sd/2hbb28EJ0fN24z4=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = [
    paho-mqtt
    typing-extensions
  ];

  pythonImportsCheck = [ "aiomqtt" ];

  nativeCheckInputs = [
    anyio
    pytestCheckHook
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
