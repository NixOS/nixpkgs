{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "sshfs.yazi";
  version = "0-unstable-2026-05-11";

  src = fetchFromGitHub {
    owner = "uhs-robert";
    repo = "sshfs.yazi";
    rev = "a8b8903c0da5a4febe91713108a9b0c8a2749475";
    hash = "sha256-RYZ0wFkYfR/TfYntRipNPvpSl4gvtmNukLBQONRk1jU=";
  };

  meta = {
    description = "Minimal SSHFS integration for the Yazi terminal file‑manager";
    homepage = "https://github.com/uhs-robert/sshfs.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilosariph ];
  };
}
