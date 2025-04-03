{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  rich,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyporscheconnectapi";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CJNE";
    repo = "pyporscheconnectapi";
    tag = version;
    hash = "sha256-MQYhIp+DUYcRKAEwcT8qzrFY043b33BHR8jma3jR0lE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    httpx
    rich
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyporscheconnectapi" ];

  meta = {
    description = "Python client library for Porsche Connect API";
    homepage = "https://github.com/CJNE/pyporscheconnectapi";
    changelog = "https://github.com/CJNE/pyporscheconnectapi/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
