{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pycryptodome,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymitsubishi";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymitsubishi";
    repo = "pymitsubishi";
    tag = "v${version}";
    hash = "sha256-tEmhllXvUwiJG1q7MyBrHPVVxzcZYgzTHzD8jnqfXvA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    pycryptodome
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pymitsubishi" ];

  meta = {
    description = "A Python library for controlling and monitoring Mitsubishi MAC-577IF-2E air conditioners";
    homepage = "https://github.com/pymitsubishi/pymitsubishi";
    changelog = "https://github.com/pymitsubishi/pymitsubishi/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uvnikita ];
  };
}
