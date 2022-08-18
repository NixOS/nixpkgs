{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, basemap-data
, cython
, geos
, numpy
, matplotlib
, pillow
, pyproj
, pyshp
, python
, setuptools
}:

buildPythonPackage rec {
  pname = "basemap";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "matplotlib";
    repo = "basemap";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-F/6xPmdXSJAuASyFaKOP+6Jz8U2JRZdqErEH7PFkr/w=";
  };

  sourceRoot = "source/packages/basemap";

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "numpy >= 1.21, < 1.23" "numpy >= 1.21, < 1.24" \
      --replace "pyshp >= 1.2, < 2.2" "pyshp >= 1.2, < 2.4"
  '';

  nativeBuildInputs = [
    cython
    geos
    setuptools
  ];

  propagatedBuildInputs = [
    basemap-data
    numpy
    matplotlib
    pillow # undocumented optional dependency
    pyproj
    pyshp
  ];

  # Standard configurePhase from `buildPythonPackage` seems to break the setup.py script
  preBuild = ''
    export GEOS_DIR=${geos}
  '';

  # test have various problems including requiring internet connection, permissions issues, problems with latest version of pillow
  doCheck = false;

  checkPhase = ''
    cd ../../examples
    export HOME=$TEMPDIR
    ${python.interpreter} run_all.py
  '';

  meta = with lib; {
    homepage = "https://matplotlib.org/basemap/";
    description = "Plot data on map projections with matplotlib";
    longDescription = ''
      An add-on toolkit for matplotlib that lets you plot data on map projections with
      coastlines, lakes, rivers and political boundaries. See
      http://matplotlib.github.com/basemap/users/examples.html for examples of what it can do.
    '';
    maintainers = with maintainers; [ ];
    license = with licenses; [ mit lgpl21 ];
  };
}
