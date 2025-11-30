{
  lib,
  buildPythonPackage,
  configparser,
  fetchFromGitHub,
  pip,
  pytest-mock,
  pytestCheckHook,
  python3-openid,
  pythonOlder,
  semantic-version,
  setuptools,
  toml,
}:

buildPythonPackage rec {
  pname = "liccheck";
  version = "0.9.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dhatim";
    repo = "python-license-check";
    tag = version;
    hash = "sha256-ohq3ZsbZcyqhwmvaVF/+mo7lNde5gjbz8pwhzHi3SPY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    configparser
    semantic-version
    toml
  ];

  nativeCheckInputs = [
    pip
    pytest-mock
    pytestCheckHook
    python3-openid
  ];

  pythonImportsCheck = [ "liccheck" ];

  meta = with lib; {
    description = "Check python packages from requirement.txt and report issues";
    homepage = "https://github.com/dhatim/python-license-check";
    changelog = "https://github.com/dhatim/python-license-check/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "liccheck";
  };
}
