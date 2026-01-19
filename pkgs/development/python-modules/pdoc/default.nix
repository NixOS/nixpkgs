{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jinja2,
  pdoc-pyo3-sample-library,
  pygments,
  markupsafe,
  pytestCheckHook,
  hypothesis,
  nix-update-script,
  markdown2,
  pydantic,
}:

buildPythonPackage rec {
  pname = "pdoc";
  version = "16.0.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "pdoc";
    tag = "v${version}";
    hash = "sha256-9amp6CWYIcniVfdlmPKYuRFR7B5JJtuMlOoDxpfvvJA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jinja2
    pygments
    markupsafe
    markdown2
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    pdoc-pyo3-sample-library
  ];
  disabledTestPaths = [
    # "test_snapshots" tries to match generated output against stored snapshots,
    # which are highly sensitive to dep versions.
    "test/test_snapshot.py"
  ];

  disabledTestMarks = [
    "slow" # skip slow tests
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pdoc" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/mitmproxy/pdoc/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://pdoc.dev/";
    description = "API Documentation for Python Projects";
    mainProgram = "pdoc";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
