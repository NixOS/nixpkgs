{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flaky,
  hypothesis,
  pytest-xdist,
  pytest7CheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "coverage";
  version = "7.13.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coveragepy";
    repo = "coveragepy";
    tag = finalAttrs.version;
    hash = "sha256-XsgOBdehJi2fIZdwE60a32+unYLSMK5MGe1nJOfPBEY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    flaky
    hypothesis
    pytest-xdist
    pytest7CheckHook
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
    changelog = "https://github.com/coveragepy/coveragepy/blob/${finalAttrs.src.tag}/CHANGES.rst";
    description = "Code coverage measurement for Python";
    homepage = "https://github.com/coveragepy/coveragepy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
