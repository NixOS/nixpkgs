{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  attrs,
  httpcore,
  httpx,
  packaging,
  protobuf,
  python-dateutil,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "e2b";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "e2b-dev";
    repo = "E2B";
    tag = "@e2b/python-sdk@${version}";
    hash = "sha256-6THRc4rv/mzOWbsN1FpUu56kjvHvVBssK2glNoGdSzI=";
  };

  sourceRoot = "${src.name}/packages/python-sdk";

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    attrs
    httpcore
    httpx
    packaging
    protobuf
    python-dateutil
    typing-extensions
  ];

  pythonImportsCheck = [ "e2b" ];

  # Tests require an API key
  # e2b.exceptions.AuthenticationException: API key is required, please visit the Team tab at https://e2b.dev/dashboard to get your API key.
  doCheck = false;

  meta = {
    description = "E2B SDK that give agents cloud environments";
    homepage = "https://github.com/e2b-dev/E2B/blob/main/packages/python-sdk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
