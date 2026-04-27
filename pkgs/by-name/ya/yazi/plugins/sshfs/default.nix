{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "sshfs.yazi";
  version = "2.0.0-unstable-2026-04-15";

  src = fetchFromGitHub {
    owner = "uhs-robert";
    repo = "sshfs.yazi";
    rev = "7ba17a8c8498fca9f0a9c437704e74b56d96ed96";
    hash = "sha256-TS3/xl8jbbCoF1LzPYvmG9BRqvlzPg4EZRErlL7S2/M=";
  };

  meta = {
    description = "Minimal SSHFS integration for the Yazi terminal file‑manager";
    homepage = "https://github.com/uhs-robert/sshfs.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilosariph ];
  };
}
