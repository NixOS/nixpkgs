{
  lib,
  buildPecl,
  fetchFromGitHub,
}:

let
  version = "1.2.1";
in
buildPecl rec {
  inherit version;
  pname = "opentelemetry";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-php-instrumentation";
    rev = version;
    hash = "sha256-zUrcikGB3O44ihcw2zOAhInfgF+sXT+Xl2lF7XJphzY=";
  };

  sourceRoot = "${src.name}/ext";

  env.NIX_CFLAGS_COMPILE = "-Wno-parentheses-equality";

  doCheck = true;

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/open-telemetry/opentelemetry-php-instrumentation/releases/tag/${version}";
    description = "OpenTelemetry PHP auto-instrumentation extension";
    homepage = "https://opentelemetry.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gaelreyrol ];
=======
  meta = with lib; {
    changelog = "https://github.com/open-telemetry/opentelemetry-php-instrumentation/releases/tag/${version}";
    description = "OpenTelemetry PHP auto-instrumentation extension";
    homepage = "https://opentelemetry.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ gaelreyrol ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
