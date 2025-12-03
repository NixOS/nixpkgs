{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  basemap-data,
  cython,
  geos,
  numpy,
  matplotlib,
  pillow,
  pyproj,
  pyshp,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "basemap";
  version = "2.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "matplotlib";
    repo = "basemap";
    tag = "v${version}";
    hash = "sha256-1T1FTcR99KbpqiYzrd2r5h1wTcygBEU7BLZXZ8uMthU=";
  };

  nativeBuildInputs = [
    cython
    geos
    setuptools
  ];

  pythonRelaxDeps = true;

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
      https://matplotlib.org/basemap/stable/users/examples.html for examples of what it can do.
    '';
    teams = [ teams.geospatial ];
    license = with licenses; [
      mit
      lgpl21
    ];
  };
}
