{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, protobuf
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-proto";
  version = "1.18.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-6iB+QlBUqRvIJ9p38NYgP4icW2rYs1P3bNCxI95cOvs=";
    sparseCheckout = [ "/${pname}" ];
  } + "/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    protobuf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.proto" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-proto";
    description = "OpenTelemetry Python Proto";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
