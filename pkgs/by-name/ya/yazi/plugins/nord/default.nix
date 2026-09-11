{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "nord.yazi";
  version = "0-unstable-2026-02-03";

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "nord.yazi";
    rev = "891f0b3048c21ce48cd73948971ebde7a73b7260";
    hash = "sha256-EcHFLYNfK4pOMxZ0anWSDUPmTQoYdAohnVAtn0XSoO8=";
  };

  meta = {
    description = "Nordic yazi";
    homepage = "https://github.com/stepbrobd/nord.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
}
