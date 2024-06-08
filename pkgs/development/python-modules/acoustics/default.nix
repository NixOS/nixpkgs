{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  matplotlib,
  numpy,
  pandas,
  pytestCheckHook,
  pythonOlder,
  scipy,
  tabulate,
}:

buildPythonPackage rec {
  pname = "acoustics";
  version = "0.2.6-unstable-2023-08-20";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-acoustics";
    repo = "python-acoustics";
    rev = "99d79206159b822ea2f4e9d27c8b2fbfeb704d38";
    hash = "sha256-/4bVjlhj8ihpAFHEWPaZ/xBILi3rb8f0NmwAexJCg+o=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
    scipy
    tabulate
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
  '';

  pytestFlagsArray = [ "-Wignore::DeprecationWarning" ];

  pythonImportsCheck = [ "acoustics" ];

  meta = with lib; {
    description = "Python package for acousticians";
    license = with licenses; [ bsd3 ];
    homepage = "https://github.com/python-acoustics/python-acoustics";
  };
}
