{
  lib,
  buildPecl,
  fetchFromGitHub,
}:

let
  version = "1.0.3";
in
buildPecl rec {
  inherit version;
  pname = "opentelemetry";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-php-instrumentation";
    rev = version;
    hash = "sha256-KqLbKnAHxXbldNYVN7eMQ7NdZmPecu0UKHQdlUm7Ur0=";
  };

  sourceRoot = "${src.name}/ext";

  env.NIX_CFLAGS_COMPILE = "-Wno-parentheses-equality";

  doCheck = true;

  meta = with lib; {
    changelog = "https://github.com/open-telemetry/opentelemetry-php-instrumentation/releases/tag/${version}";
    description = "OpenTelemetry PHP auto-instrumentation extension";
    homepage = "https://opentelemetry.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ gaelreyrol ];
  };
}
