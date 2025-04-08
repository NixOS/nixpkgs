{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "relative-motions.yazi";
  version = "25.2.7-unstable-2025-04-07";

  src = fetchFromGitHub {
    owner = "dedukun";
    repo = "relative-motions.yazi";
    rev = "61ae7950daeea3e1d960aa777b7a07cde4539b29";
    hash = "sha256-L5B5X762rBoxgKrUi0uRLDmAOJ/jPALc2bP9MYLiGYw=";
  };

  meta = {
    description = "Yazi plugin based about vim motions.";
    homepage = "https://github.com/dedukun/relative-motions.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
