{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "sshfs.yazi";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "uhs-robert";
    repo = "sshfs.yazi";
    tag = "v2.1.0";
    hash = "sha256-02LzKNptzs6o+YPGJRyYCly/Xqzi/5mvVBS+b28nY6U=";
  };

  meta = {
    description = "Minimal SSHFS integration for the Yazi terminal file‑manager";
    homepage = "https://github.com/uhs-robert/sshfs.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilosariph ];
  };
}
