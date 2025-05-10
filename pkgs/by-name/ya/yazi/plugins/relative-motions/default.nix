{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "relative-motions.yazi";
  version = "25.4.8-unstable-2025-04-16";

  src = fetchFromGitHub {
    owner = "dedukun";
    repo = "relative-motions.yazi";
    rev = "ce2e890227269cc15cdc71d23b35a58fae6d2c27";
    hash = "sha256-Ijz1wYt+L+24Fb/rzHcDR8JBv84z2UxdCIPqTdzbD14=";
  };

  meta = {
    description = "Yazi plugin based about vim motions";
    homepage = "https://github.com/dedukun/relative-motions.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
