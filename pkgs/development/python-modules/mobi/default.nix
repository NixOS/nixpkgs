{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  loguru,
  poetry-core,
  setuptools,
  standard-imghdr,
}:

buildPythonPackage rec {
  pname = "mobi";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iscc";
    repo = "mobi";
    tag = "v${version}";
    hash = "sha256-Hbw4TX/yKkuxYQ9vZZp/wasDCop8pvyQc5zWloMQbng=";
  };

  pythonRelaxDeps = [ "loguru" ];

  dependencies = [ standard-imghdr ];

  nativeBuildInputs = [
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [ loguru ];

  pythonImportsCheck = [ "mobi" ];

  meta = {
    description = "Library for unpacking unencrypted mobi files";
    mainProgram = "mobiunpack";
    homepage = "https://github.com/iscc/mobi";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
