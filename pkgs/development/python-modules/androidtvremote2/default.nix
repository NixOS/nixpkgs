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
  version = "0.0.11";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "androidtvremote2";
    rev = "refs/tags/v${version}";
    hash = "sha256-mjhohkAC6g2UJgPbq/29Awyy6c4M8SnLqr5v5g7+IeE=";
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
