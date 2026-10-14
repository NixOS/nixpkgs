{
  lib,
  buildPythonPackage,
  configparser,
  fetchFromGitHub,
  pip,
  pkg-resources-backport,
  pytest-mock,
  pytestCheckHook,
  python3-openid,
  semantic-version,
  setuptools,
  toml,
}:

buildPythonPackage (finalAttrs: {
  pname = "liccheck";
  version = "0.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dhatim";
    repo = "python-license-check";
    tag = finalAttrs.version;
    hash = "sha256-ohq3ZsbZcyqhwmvaVF/+mo7lNde5gjbz8pwhzHi3SPY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    configparser
    pkg-resources-backport
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

  meta = {
    description = "Check python packages from requirement.txt and report issues";
    homepage = "https://github.com/dhatim/python-license-check";
    changelog = "https://github.com/dhatim/python-license-check/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "liccheck";
  };
})
