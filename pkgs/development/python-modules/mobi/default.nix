{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  loguru,
  hatchling,
  standard-imghdr,
  pytestCheckHook,
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

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "loguru" ];

  dependencies = [
    loguru
    standard-imghdr
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mobi" ];

  meta = {
    description = "Library for unpacking unencrypted mobi files";
    mainProgram = "mobiunpack";
    homepage = "https://github.com/iscc/mobi";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
