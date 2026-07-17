{
  lib,
  buildPecl,
  fetchFromGitHub,
}:

let
  version = "1.4.0";
in
buildPecl rec {
  inherit version;
  pname = "opentelemetry";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-php-instrumentation";
    rev = version;
    hash = "sha256-B+PpKXsKQscBafk6bcpwHXzCA12qQ0HXv8SWRe/nIR0=";
  };

  sourceRoot = "${src.name}/ext";

  env.NIX_CFLAGS_COMPILE = "-Wno-parentheses-equality";

  doCheck = true;

  meta = {
    changelog = "https://github.com/open-telemetry/opentelemetry-php-instrumentation/releases/tag/${version}";
    description = "OpenTelemetry PHP auto-instrumentation extension";
    homepage = "https://opentelemetry.io/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
