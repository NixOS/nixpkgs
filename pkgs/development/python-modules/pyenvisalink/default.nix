{
  lib,
  async-timeout,
  buildPythonPackage,
  colorlog,
  fetchPypi,
  pyserial,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyenvisalink";
  version = "4.9";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-WtBopLUCArWM4JwA517bnYidfOwqU3v7ApZCbsMuY/o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    async-timeout
    colorlog
    pyserial
  ];

  # Tests require an Envisalink device
  doCheck = false;

  pythonImportsCheck = [ "pyenvisalink" ];

  meta = {
    description = "Python interface for Envisalink 2DS/3 Alarm API";
    homepage = "https://github.com/Cinntax/pyenvisalink";
    changelog = "https://github.com/ufodone/pyenvisalink/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
