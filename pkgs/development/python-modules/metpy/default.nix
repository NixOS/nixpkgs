{ lib
, buildPythonPackage
, fetchPypi
, matplotlib
, pint
, pooch
, pyproj
, pytest-mpl
, pytestCheckHook
, scipy
, setuptools
, setuptools-scm
, traitlets
, xarray
}:

buildPythonPackage rec {
  pname = "metpy";
  version = "1.6.2";
  pyproject = true;

  src = fetchPypi {
    pname = "MetPy";
    inherit version;
    hash = "sha256-6wZbrA14GFh/o4+myW3+cg2dFbWa9OSGZUGJTiZ0drs=";
  };

  nativeBuildInputs = [ setuptools setuptools-scm ];

  propagatedBuildInputs = [
    matplotlib
    pint
    pooch
    pyproj
    scipy
    traitlets
    xarray
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ pytest-mpl ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Many tests require fetching data from GitHub
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Unidata/MetPy";
    description = "Tools for reading, visualizing and performing calculations with weather data";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matrss ];
  };
}
