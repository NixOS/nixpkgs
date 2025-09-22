{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  astunparse,
  grpcio-tools,
  click,
  pkgs,
  protobuf,
  mypy-protobuf,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage rec {
  pname = "protoletariat";
  version = "3.3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cpcloud";
    repo = "protoletariat";
    tag = version;
    hash = "sha256-oaZmgen/7WkX+nNuphrcyniL7Z/OaeqlcnbCnqR5h0w=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    astunparse
    click
    grpcio-tools
    protobuf
  ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  postPatch = ''
    substituteInPlace protoletariat/__main__.py \
      --replace-fail 'default="protoc",' 'default="${lib.getExe' pkgs.protobuf "protoc"}",'
  '';

  pythonImportsCheck = [ "protoletariat" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
    mypy-protobuf
  ];

  meta = {
    description = "Python protocol buffers for the rest of us";
    changelog = "https://github.com/cpcloud/protoletariat/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
