{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  dotmap,
  matplotlib,
  pyclipper,
  pytestCheckHook,
  pythonImportsCheckHook,
  setuptools,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "beziers";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simoncozens";
    repo = "beziers.py";
    rev = "v${version}";
    hash = "sha256-NjmWsRz/NPPwXPbiSaOeKJMrYmSyNTt5ikONyAljgvM=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyclipper ];

  preCheck = ''
    # silence matplotlib warning
    export MPLCONFIGDIR=$(mktemp -d)
  '';

  nativeCheckInputs = [
    dotmap
    matplotlib
    pytestCheckHook
    pythonImportsCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # Fails on macOS with Trace/BPT trap: 5 - something to do with recursion depth
    "test_cubic_cubic"
  ];

  pythonImportsCheckFlags = [ "beziers" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Python library for manipulating Bezier curves and paths in fonts";
    homepage = "https://github.com/simoncozens/beziers.py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danc86 ];
  };
}
