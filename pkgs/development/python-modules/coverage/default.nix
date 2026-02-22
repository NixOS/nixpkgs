{
  lib,
  stdenv,
  buildPythonPackage,
  isPy312,
  fetchFromGitHub,
  flaky,
  hypothesis,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "7.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coveragepy";
    repo = "coveragepy";
    tag = version;
    hash = "sha256-dYgZLAiuPwYs4NomT+c2KS9VXXYEMW8oyHk2y4TCwe0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    flaky
    hypothesis
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin"
    # import from $out
    rm -r coverage
  '';

  disabledTests = [
    # tests expect coverage source to be there
    "test_all_our_source_files"
    "test_real_code_regions"
  ];

  meta = {
    changelog = "https://github.com/coveragepy/coveragepy/blob/${src.tag}/CHANGES.rst";
    description = "Code coverage measurement for Python";
    homepage = "https://github.com/coveragepy/coveragepy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
