{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "nord.yazi";
  version = "0-unstable-2025-05-14";

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "nord.yazi";
    rev = "0f8eff4367021be1b741391d98853fbd1a34baf9";
    hash = "sha256-bcYIbKFU1bvGRS6lgEBMe2jT13bECYgQATuh3QKmhQE=";
  };

  meta = {
    description = "nordic yazi";
    homepage = "https://github.com/stepbrobd/nord.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
}
