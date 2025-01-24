{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pyjwt,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "homepluscontrol";
  version = "0.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "chemaaa";
    repo = pname;
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

  meta = with lib; {
    description = "Python API to interact with the Legrand Eliot Home and Control";
    homepage = "https://github.com/chemaaa/homepluscontrol";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
