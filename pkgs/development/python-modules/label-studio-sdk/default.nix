{
  appdirs,
  buildPythonPackage,
  datamodel-code-generator,
  fetchFromGitHub,
  httpx,
  ijson,
  jsf,
  jsonschema,
  lib,
  lxml,
  nix-update-script,
  nltk,
  numpy,
  opencv-python-headless,
  pandas,
  pillow,
  poetry-core,
  pydantic,
  pydantic-core,
  pyjwt,
  pytestCheckHook,
  pytest-asyncio,
  requests,
  requests-mock,
  typing-extensions,
  ujson,
  urllib3,
  writableTmpDirAsHomeHook,
  xmljson,
}:

buildPythonPackage rec {
  pname = "label_studio_sdk";
  version = "2.0.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HumanSignal";
    repo = "label-studio-sdk";
    tag = version;
    hash = "sha256-kC1fP7qBQB0dJA8yQecPZB7cS6Vw9Cc8Y/3j2A6TyOw=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pillow
    appdirs
    datamodel-code-generator
    httpx
    ijson
    jsf
    jsonschema
    lxml
    nltk
    numpy
    opencv-python-headless
    pandas
    pydantic
    pydantic-core
    pyjwt
    requests
    requests-mock
    typing-extensions
    ujson
    urllib3
    xmljson
  ];

  pythonRelaxDeps = [ "datamodel-code-generator" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    writableTmpDirAsHomeHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convenient access to the Label Studio API for python applications";
    homepage = "https://github.com/HumanSignal/label-studio-sdk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mrtipson ];
    changelog = "https://github.com/HumanSignal/label-studio-sdk/releases/tag/${src.tag}";
  };
}
