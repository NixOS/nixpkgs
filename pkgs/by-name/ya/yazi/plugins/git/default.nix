{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "git.yazi";
  version = "25.2.26-unstable-2025-03-17";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "79193b3917d0f1b82ee41b4e64ae4df58f2284f6";
    hash = "sha256-ZLL/dFjNsryjm51kFNOmw5DhSGl2K5IfatHpe1PkuFE=";
  };

  meta = {
    description = "Show the status of Git file changes as linemode in the file list";
    homepage = "https://yazi-rs.github.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
