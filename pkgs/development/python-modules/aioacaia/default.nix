{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioacaia";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "aioacaia";
    tag = "v${version}";
    hash = "sha256-bwfJTSVVw9TVmpUdhHrLDD+yU6D90xfIL1+6GWxDdE8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  # Module only has a homebrew tests
  doCheck = false;

  pythonImportsCheck = [ "aioacaia" ];

  meta = {
    description = "Async implementation of pyacaia";
    homepage = "https://github.com/zweckj/aioacaia";
    changelog = "https://github.com/zweckj/aioacaia/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
