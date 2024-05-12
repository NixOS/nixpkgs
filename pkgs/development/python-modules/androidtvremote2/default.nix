{ lib
, aiofiles
, buildPythonPackage
, cryptography
, fetchFromGitHub
, protobuf
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "androidtvremote2";
  version = "0.0.15";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "androidtvremote2";
    rev = "refs/tags/v${version}";
    hash = "sha256-aLNmuMuwaMhl/Utv6bVU4fR8zmhj0fUiInL4RHT4dVw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiofiles
    cryptography
    protobuf
  ];

  pythonImportsCheck = [
    "androidtvremote2"
  ];

  # Module only has a dummy test
  doCheck = false;

  meta = with lib; {
    description = "Library to interact with the Android TV Remote protocol v2";
    homepage = "https://github.com/tronikos/androidtvremote2";
    changelog = "https://github.com/tronikos/androidtvremote2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
