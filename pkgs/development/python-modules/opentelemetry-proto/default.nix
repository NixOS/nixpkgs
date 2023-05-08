{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, protobuf
}:

buildPythonPackage rec {
  pname = "opentelemetry-proto";
  version = "1.17.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "v${version}";
    hash = "sha256-vYbkdDcmekT7hhFb/ivp5/0QakHd0DzMRLZEIjVgXkE=";
  };
  sourceRoot = "source/opentelemetry-proto";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    protobuf
  ];

  pythonImportsCheck = [ "opentelemetry.proto" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
