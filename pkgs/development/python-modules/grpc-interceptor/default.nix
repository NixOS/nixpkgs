{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  grpcio,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "grpc-interceptor";
  version = "0.15.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "d5h-foss";
    repo = "grpc-interceptor";
    tag = "v${version}";
    hash = "sha256-GJkVCslPXShJNDrqhFtCsAK5+VaG8qFJo0RQTsiMIFY=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "grpc_interceptor" ];

  meta = {
    description = "Simplified gRPC interceptors";
    homepage = "https://github.com/d5h-foss/grpc-interceptor";
    changelog = "https://github.com/d5h-foss/grpc-interceptor/releases/tag/v${version}";
    longDescription = ''
      Simplified Python gRPC interceptors.

      The Python gRPC package provides service interceptors, but they're a bit
      hard to use because of their flexibility. The gRPC interceptors don't
      have direct access to the request and response objects, or the service
      context. Access to these are often desired, to be able to log data in the
      request or response, or set status codes on the context.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomaskala ];
  };
}
