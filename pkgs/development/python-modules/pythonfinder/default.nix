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

buildPythonPackage (finalAttrs: {
  pname = "pythonfinder";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "pythonfinder";
    tag = finalAttrs.version;
    hash = "sha256-p+r/0MjxhMcc0n5gPEbdGjC2M+yGqGT/YvxlyU8xTtA=";
  };

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  optional-dependencies = {
    cli = [ click ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "pythonfinder" ];

  meta = {
    description = "Cross platform search tool for finding Python";
    homepage = "https://github.com/sarugaku/pythonfinder";
    changelog = "https://github.com/sarugaku/pythonfinder/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
    mainProgram = "pyfinder";
  };
})
