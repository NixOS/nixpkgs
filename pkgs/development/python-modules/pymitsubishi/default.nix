{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pycryptodome,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymitsubishi";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymitsubishi";
    repo = "pymitsubishi";
    tag = "v${version}";
    hash = "sha256-oMv+GKdl1H1S5mYUYfTUHuLM5yvkvD44dy9DEsQVAyg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    pycryptodome
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pymitsubishi" ];

  meta = {
    description = "Library for controlling and monitoring Mitsubishi MAC-577IF-2E air conditioners";
    homepage = "https://github.com/pymitsubishi/pymitsubishi";
    changelog = "https://github.com/pymitsubishi/pymitsubishi/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uvnikita ];
  };
}
