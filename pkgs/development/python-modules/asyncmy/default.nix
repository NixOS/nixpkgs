{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  poetry-core,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "asyncmy";
  version = "0.2.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "long2ice";
    repo = "asyncmy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bUpuFHfHW5mDtcbLk7Ro2gGq48sw3v3adY8tQ23e460=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  # Not running tests as aiomysql is missing support for pymysql>=0.9.3
  doCheck = false;

  pythonImportsCheck = [ "asyncmy" ];

  meta = {
    description = "Python module to interact with MySQL/mariaDB";
    homepage = "https://github.com/long2ice/asyncmy";
    changelog = "https://github.com/long2ice/asyncmy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
