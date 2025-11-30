{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bot-safe-agents";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ivan-sincek";
    repo = "bot-safe-agents";
    tag = "v${version}";
    hash = "sha256-x+AoHg8JFq++qZIhxljIZp2pfxEd0jtETclttddN4sk=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "bot_safe_agents" ];

  meta = {
    description = "Library for fetching a list of bot-safe user agents";
    homepage = "https://github.com/ivan-sincek/bot-safe-agents";
    changelog = "https://github.com/ivan-sincek/bot-safe-agents/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
