{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "faster-piper.yazi";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "alberti42";
    repo = "faster-piper.yazi";
    rev = "3bb7be5b5327069ee01c8f445e2b93aee6a3c13e";
    hash = "sha256-Rr1JYSDi4wWQu5DTMu3i2NfrXNG46idXKYJtRTuD38c=";
  };

  meta = {
    description = "A fast, cache-aware reimplementation of piper.yazi for Yazi.";
    homepage = "https://github.com/alberti42/faster-piper.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bentenjamin ];
  };
}
