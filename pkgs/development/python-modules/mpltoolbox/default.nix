{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  matplotlib,
  ipympl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mpltoolbox";
  version = "25.05.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "mpltoolbox";
    tag = version;
    hash = "sha256-XDfCzkn/Mr0Rca+Ku/mDSneqSfMHS9i/XUP8vVLSKMQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    matplotlib
  ];

  nativeCheckInputs = [
    ipympl
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mpltoolbox"
  ];

  meta = {
    description = "Interactive tools for Matplotlib";
    homepage = "https://scipp.github.io/mpltoolbox/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
