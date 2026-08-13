{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "aiomusiccast";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vigonotion";
    repo = "aiomusiccast";
    tag = version;
    hash = "sha256-oFA8i/cdDqOQ9Fq0VWd8eiOg8F1+MNxWanNqoao5+pM=";
  };

  postPatch = ''
    substituteInPlace aiomusiccast/__init__.py \
      --replace-fail '__version__ = "0.0.0"' '__version__ = "${version}"'
  '';

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiomusiccast" ];

  meta = {
    description = "Companion library for musiccast devices intended for the Home Assistant integration";
    homepage = "https://github.com/vigonotion/aiomusiccast";
    changelog = "https://github.com/vigonotion/aiomusiccast/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
