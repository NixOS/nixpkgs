{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "nord.yazi";
  version = "0-unstable-2026-10-23";

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "nord.yazi";
    rev = "4712015c399cad806572661b0a07b876931e2860";
    hash = "sha256-ngCrjQg95V7T0BY0VXnASuzSZL4L0NrUlQx1tZc/RkM=";
  };

  meta = {
    description = "Nordic yazi";
    homepage = "https://github.com/stepbrobd/nord.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
}
