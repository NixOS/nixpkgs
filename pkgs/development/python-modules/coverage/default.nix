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

buildPythonPackage rec {
  pname = "coverage";
  version = "7.13.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coveragepy";
    repo = "coveragepy";
    tag = version;
    hash = "sha256-QWwaZDX3qW8AWbx5McOI5S+UO63/jGyRcycNSkAEgro=";
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
    changelog = "https://github.com/coveragepy/coveragepy/blob/${src.tag}/CHANGES.rst";
    description = "Code coverage measurement for Python";
    homepage = "https://github.com/coveragepy/coveragepy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
