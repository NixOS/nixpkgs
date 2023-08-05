{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, grpcio
, protobuf
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "grpc-interceptor";
  version = "0.15.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "d5h-foss";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-zulK0SVehzHcrmgIyH0D5sUOiAN53eIg88IoVyF6/DA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

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
