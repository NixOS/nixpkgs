{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
}:

buildPythonPackage rec {
  pname = "util/opentelemetry-util-http";
  version = "0.38b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "v${version}";
    hash = "sha256-j1r1uhssDufBQ28GB1tWA76FGfcJ/qbgPzWpakWVOcM=";
  };
  sourceRoot = "source/util/opentelemetry-util-http";

  nativeBuildInputs = [
    hatchling
  ];

  pythonImportsCheck = [ "opentelemetry" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
