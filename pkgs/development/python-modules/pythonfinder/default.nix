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
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "pythonfinder";
    tag = version;
    hash = "sha256-Qym/t+IejBMFHvBfIm+G5+J3GBC9O3RFrwSqHLuxwcg=";
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
