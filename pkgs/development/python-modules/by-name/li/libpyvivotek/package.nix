{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "libpyvivotek";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HarlemSquirrel";
    repo = "python-vivotek";
    tag = "v${version}";
    hash = "sha256-ai+FlvyrdeLyg/PJU8T0fTtbdnlyGo6mE4AM2oRATj8=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [ "libpyvivotek" ];

  meta = with lib; {
    description = "Python Library for Vivotek IP Cameras";
    homepage = "https://github.com/HarlemSquirrel/python-vivotek";
    changelog = "https://github.com/HarlemSquirrel/python-vivotek/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
