{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "aioapcaccess";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yuxincs";
    repo = "aioapcaccess";
    tag = "v${version}";
    hash = "sha256-nI8hfHfSLMOKPcG5idYqqa/msJuR/Xt+JmgzdftlN28=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioapcaccess" ];

  meta = with lib; {
    description = "Module for working with apcaccess";
    homepage = "https://github.com/yuxincs/aioapcaccess";
    changelog = "https://github.com/yuxincs/aioapcaccess/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
