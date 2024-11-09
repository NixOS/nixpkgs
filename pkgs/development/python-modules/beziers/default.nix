{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dotmap,
  matplotlib,
  pyclipper,
  unittestCheckHook,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "beziers";
  version = "0.6.0";
  format = "setuptools";

  # PyPI doesn't have a proper source tarball, fetch from Github instead
  src = fetchFromGitHub {
    owner = "simoncozens";
    repo = "beziers.py";
    rev = "v${version}";
    hash = "sha256-NjmWsRz/NPPwXPbiSaOeKJMrYmSyNTt5ikONyAljgvM=";
  };

  propagatedBuildInputs = [ pyclipper ];

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

  meta = with lib; {
    description = "Python library for manipulating Bezier curves and paths in fonts";
    homepage = "https://github.com/simoncozens/beziers.py";
    license = licenses.mit;
    maintainers = with maintainers; [ danc86 ];
  };
}
