{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pyjwt,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "homepluscontrol";
  version = "0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "chemaaa";
    repo = "homepluscontrol";
    rev = version;
    hash = "sha256-COOGqfYiR4tueQHXuCvVxShrYS0XNltcW4mclbFWcfA=";
  };

  propagatedBuildInputs = [
    aiohttp
    pyjwt
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
  ];

  pythonImportsCheck = [ "homepluscontrol" ];

  meta = {
    description = "Python API to interact with the Legrand Eliot Home and Control";
    homepage = "https://github.com/chemaaa/homepluscontrol";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
