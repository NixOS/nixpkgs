{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "aiobafi6";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jfroy";
    repo = "aiobafi6";
    tag = version;
    hash = "sha256-7NIpIRVs6PFPByrGfVDA6P7JTvXGrzbH/lOPdPfZH04=";
  };

  build-system = [ poetry-core ];

  dependencies = [
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
    homepage = "https://github.com/jfroy/aiobafi6";
    changelog = "https://github.com/jfroy/aiobafi6/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "aiobafi6";
  };
}
