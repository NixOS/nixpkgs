{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pytest-cases,
  pytest-cov,
  zip,
}:

buildPythonPackage rec {
  pname = "repro-zipfile";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "drivendataorg";
    repo = "repro-zipfile";
    rev = "v${version}";
    hash = "sha256-UpxgxD6KhtMlo7iKjcciQouiJumC4ogqUflibJFvRsQ=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [
    "repro_zipfile"
  ];

  disabledTestPaths = [
    "tests/test_cli.py" # those tests depend on the cli "rpzip" which depends on repro-zipfile (circular dependencies)
  ];

  # without that the "test_writestr" test with python 3.14 fails
  preCheck = ''
    unset SOURCE_DATE_EPOCH
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cases
    pytest-cov
  ];

  meta = {
    description = "A tiny, zero-dependency replacement for Python's zipfile.ZipFile for creating reproducible/deterministic ZIP archives";
    homepage = "https://github.com/drivendataorg/repro-zipfile";
    changelog = "https://github.com/drivendataorg/repro-zipfile/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      psfl
    ];
    maintainers = with lib.maintainers; [ xavwe ];
  };
}
