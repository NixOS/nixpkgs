{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "nord.yazi";
  version = "0-unstable-2025-05-20";

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "nord.yazi";
    rev = "c9a58b4361ac82d5ddc91e6e27b620bb096d0bee";
    hash = "sha256-yjxdoZlOPFliNbp+SwNFd+PPWlD7j8edXC8urQo7WZA=";
  };

  meta = {
    description = "Nordic yazi";
    homepage = "https://github.com/stepbrobd/nord.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
}
