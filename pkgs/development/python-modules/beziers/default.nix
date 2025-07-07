{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dotmap,
  matplotlib,
  pyclipper,
  setuptools,
  unittestCheckHook,
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

  nativeCheckInputs = [
    dotmap
    matplotlib
    unittestCheckHook
  ];
  unittestFlagsArray = [
    "-s"
    "test"
    "-v"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Python library for manipulating Bezier curves and paths in fonts";
    homepage = "https://github.com/simoncozens/beziers.py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danc86 ];
  };
}
