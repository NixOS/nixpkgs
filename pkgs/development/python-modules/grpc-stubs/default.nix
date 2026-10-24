{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  grpcio,
  pythonOlder,
  pytestCheckHook,
  pytest-mypy-plugins,
  types-protobuf,
  setuptools,
}:

buildPythonPackage rec {
  pname = "grpc-stubs";
  version = "1.53.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shabbyrobe";
    repo = "grpc-stubs";
    tag = version;
    hash = "sha256-an7xztaCqxOEmf74Rgb8q9u/WsojFYkBiwtLRa1qqBQ=";
  };

  disabled = pythonOlder "3.6";

  dependencies = [
    types-protobuf
  ];

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    grpcio
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mypy-plugins
  ];

  meta = {
    description = "gRPC typing stubs for Python";
    homepage = "https://github.com/shabbyrobe/grpc-stubs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ coastalwhite ];
  };
}
