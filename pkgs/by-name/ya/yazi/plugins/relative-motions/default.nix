{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "relative-motions.yazi";
  version = "25.5.28-unstable-2025-07-09";

  src = fetchFromGitHub {
    owner = "dedukun";
    repo = "relative-motions.yazi";
    rev = "a603d9ea924dfc0610bcf9d3129e7cba605d4501";
    hash = "sha256-9i6x/VxGOA3bB3FPieB7mQ1zGaMK5wnMhYqsq4CvaM4=";
  };

  meta = {
    description = "Yazi plugin based about vim motions";
    homepage = "https://github.com/dedukun/relative-motions.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
