{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  packaging,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pythonfinder";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "pythonfinder";
    tag = version;
    hash = "sha256-p+r/0MjxhMcc0n5gPEbdGjC2M+yGqGT/YvxlyU8xTtA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ packaging ];

  optional-dependencies = {
    cli = [ click ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "pythonfinder" ];

  meta = {
    description = "Cross platform search tool for finding Python";
    mainProgram = "pyfinder";
    homepage = "https://github.com/sarugaku/pythonfinder";
    changelog = "https://github.com/sarugaku/pythonfinder/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
