{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pybrowsers";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = "browsers";
    tag = version;
    hash = "sha256-yTEqqGbwvpNyY/lOs3wjmXngclxv3dOb7jzlmJKMwG0=";
  };

  build-system = [ poetry-core ];

  # Tests want to interact with actual browsers
  doCheck = false;

  pythonImportsCheck = [ "browsers" ];

  meta = {
    description = "Python library for detecting and launching browsers";
    homepage = "https://github.com/roniemartinez/browsers";
    changelog = "https://github.com/roniemartinez/browsers/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
