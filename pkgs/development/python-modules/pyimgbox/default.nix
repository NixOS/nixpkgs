{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  beautifulsoup4,
  httpx,
  pytest-asyncio,
  pytest-httpserver,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyimgbox";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "plotski";
    repo = "pyimgbox";
    tag = "v${finalAttrs.version}";
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
})
