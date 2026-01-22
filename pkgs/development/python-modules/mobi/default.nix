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
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iscc";
    repo = "mobi";
    tag = "v${version}";
    hash = "sha256-g1L72MkJdrKQRsEdew+Qsn8LfCn8+cmj2pmY6s4nv2U=";
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
