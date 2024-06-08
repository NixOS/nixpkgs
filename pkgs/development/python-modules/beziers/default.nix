{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dotmap,
  matplotlib,
  pyclipper,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "beziers";
  version = "0.5.0";
  format = "setuptools";

  # PyPI doesn't have a proper source tarball, fetch from Github instead
  src = fetchFromGitHub {
    owner = "simoncozens";
    repo = "beziers.py";
    rev = "v${version}";
    hash = "sha256-4014u7s47Tfdpa2Q9hKAoHg7Ebcs1/DVW5TpEmoh2bc=";
  };

  propagatedBuildInputs = [ pyclipper ];

  doCheck = true;
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

  meta = with lib; {
    description = "Python library for manipulating Bezier curves and paths in fonts";
    homepage = "https://github.com/simoncozens/beziers.py";
    license = licenses.mit;
    maintainers = with maintainers; [ danc86 ];
  };
}
