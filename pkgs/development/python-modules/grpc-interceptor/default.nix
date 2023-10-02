{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, poetry-core
, grpcio
, protobuf
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "grpc-interceptor";
  version = "0.15.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "d5h-foss";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-tTi1X1r7584ZXa12eLp2G/Am8G6Dnd18eE5wF/Lp/EY=";
  };

  patches = [
    # https://github.com/d5h-foss/grpc-interceptor/pull/44
    (fetchpatch {
      name = "replace-poetry-with-poetry-core.patch";
      url = "https://github.com/d5h-foss/grpc-interceptor/commit/916cb394acd8dd7abb4f5edcb4e88aee961a32d0.patch";
      hash = "sha256-W2SF2zyjusTxgvCxBDLpisD03bofzDug1eyd4FLJmKs=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "grpc_interceptor"
  ];

  meta = with lib; {
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
    license = licenses.mit;
    maintainers = with maintainers; [ tomaskala ];
  };
}
