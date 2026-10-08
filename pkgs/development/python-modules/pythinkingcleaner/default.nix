{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pythinkingcleaner";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TheRealLink";
    repo = "pythinkingcleaner";
    tag = version;
    hash = "sha256-YaHBZwJvgI3uFkFtZ4KWrKKGRPuNhBBrhCvGC65Jsks=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "pythinkingcleaner" ];

  meta = {
    description = "Library to control ThinkingCleaner devices";
    homepage = "https://github.com/TheRealLink/pythinkingcleaner";
    changelog = "https://github.com/TheRealLink/pythinkingcleaner/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
