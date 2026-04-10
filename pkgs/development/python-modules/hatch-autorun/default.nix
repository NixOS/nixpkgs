{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
  build,
}:

buildPythonPackage rec {
  pname = "hatch-autorun";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ofek";
    repo = "hatch-autorun";
    tag = "v${version}";
    hash = "sha256-79k3KolvmjGf8ubCQMhtOH5+OeqQrmz2Q6r0ZG98424=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    hatchling
  ];

  pythonImportsCheck = [
    "hatch_autorun"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    build
  ];

  disabledTestPaths = [
    # requires network via invoking pip
    "tests/test_build.py"
  ];

  meta = {
    description = "Hatch build hook plugin to inject code that will automatically run";
    homepage = "https://github.com/ofek/hatch-autorun";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
