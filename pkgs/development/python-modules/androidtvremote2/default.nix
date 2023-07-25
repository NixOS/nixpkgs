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
  version = "0.0.12";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "androidtvremote2";
    rev = "refs/tags/v${version}";
    hash = "sha256-A/1zNBrYo9oPAVexq/W2G9mqBeTsUvF5/T2db6g9AGk=";
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
