{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin (finalAttrs: {
  pname = "sshfs.yazi";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "uhs-robert";
    repo = "sshfs.yazi";
    tag = "v2.1.1";
    hash = "sha256-RYZ0wFkYfR/TfYntRipNPvpSl4gvtmNukLBQONRk1jU=";
  };

  meta = {
    description = "Minimal SSHFS integration for the Yazi terminal file‑manager";
    homepage = "https://github.com/uhs-robert/sshfs.yazi";
    changelog = "https://github.com/uhs-robert/sshfs.yazi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilosariph ];
  };
})
