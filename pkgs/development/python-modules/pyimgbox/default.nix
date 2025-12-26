{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  beautifulsoup4,
  httpx,
  pytest-asyncio,
  pytest-httpserver,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyimgbox";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "plotski";
    repo = "pyimgbox";
    tag = "v${version}";
    hash = "sha256-HYKi5nYXJ+5ytQEFVMMm1HxEsD1zMU7cE2mOdwuZxvk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    httpx
    beautifulsoup4
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpserver
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyimgbox" ];

  meta = {
    description = "API for uploading images to imgbox.com";
    homepage = "https://codeberg.org/plotski/pyimgbox";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
