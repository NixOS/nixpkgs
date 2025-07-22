{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "custom-shell.yazi";
  version = "1-unstable-2025-01-07";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "custom-shell.yazi";
    rev = "b04213d2f4ca6079bef37491be07860baa8264b9";
    hash = "sha256-hJVFZvcHgcjmcwUUGs1Q668KjeLSCEVuAhAD1A8ZM90=";
  };

  meta = {
    description = "Gives comprehensive shell integration";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
  };
}
