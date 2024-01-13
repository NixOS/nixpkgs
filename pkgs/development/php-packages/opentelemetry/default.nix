{ lib, buildPecl, fetchFromGitHub }:

let
  version = "1.0.0";
in buildPecl {
  inherit version;
  pname = "opentelemetry";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-php-instrumentation";
    rev = version;
    hash = "sha256-uCsm2vsxXfbEH9spCgWHhmqzyRH9k8kqIAIdQk5CNYg=";
  };

  sourceRoot = "source/ext";

  doCheck = true;

  meta = with lib; {
    changelog = "https://github.com/open-telemetry/opentelemetry-php-instrumentation/releases/tag/${version}";
    description = "OpenTelemetry PHP auto-instrumentation extension";
    homepage = "https://opentelemetry.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ gaelreyrol ];
  };
}
