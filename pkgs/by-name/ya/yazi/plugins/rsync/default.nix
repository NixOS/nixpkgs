{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "rsync.yazi";
  version = "0-unstable-2025-06-07";
  src = fetchFromGitHub {
    owner = "GianniBYoung";
    repo = "rsync.yazi";
    rev = "782481e58316f4b422f5c259f07c63b940555246";
    hash = "sha256-ZrvaJl3nf/CGavvk1QEyOMUbfKQ/JYSmZguvbXIIw9M=";
  };

  meta = {
    description = "Simple rsync plugin for yazi file manager";
    homepage = "https://github.com/GianniBYoung/rsync.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
  };
}
