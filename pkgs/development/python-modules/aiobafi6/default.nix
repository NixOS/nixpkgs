{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "aiobafi6";
  version = "0.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jfroy";
    repo = "aiobafi6";
    rev = "refs/tags/${version}";
    hash = "sha256-QxjrspvNrcMcGChjj1B4QF/SnWCsGmPxnI2bWAL6BiI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    protobuf
    zeroconf
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiobafi6" ];

  meta = with lib; {
    description = "Library for communication with the Big Ass Fans i6 firmware";
    mainProgram = "aiobafi6";
    homepage = "https://github.com/jfroy/aiobafi6";
    changelog = "https://github.com/jfroy/aiobafi6/releases/tag/0.8.2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
