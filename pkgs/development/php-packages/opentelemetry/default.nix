{ lib, buildPecl, fetchFromGitHub }:

let
  version = "1.0.1";
in buildPecl rec {
  inherit version;
  pname = "opentelemetry";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-php-instrumentation";
    rev = version;
    hash = "sha256-VHUzRhTtHygHoW+poItaphV+mxe4rmmSfGgesUgPz8Q=";
  };

  sourceRoot = "${src.name}/ext";

  doCheck = true;

  meta = with lib; {
    changelog = "https://github.com/open-telemetry/opentelemetry-php-instrumentation/releases/tag/${version}";
    description = "OpenTelemetry PHP auto-instrumentation extension";
    homepage = "https://opentelemetry.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ gaelreyrol ];
  };
}
