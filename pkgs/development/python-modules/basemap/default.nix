{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, numpy
, matplotlib
, pillow
, setuptools
, pyproj
, pyshp
, six
, pkgs
}:

buildPythonPackage rec {
  pname = "basemap";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "matplotlib";
    repo = "basemap";
    rev = "v${version}";
    sha256 = "0nwpd6zx2q2fc556ppz71ra6ad9z0d5bz8hcld64i91dcy0f0zs3";
  };

  propagatedBuildInputs = [ numpy matplotlib pillow pyproj pyshp six ];
  buildInputs = [ setuptools pkgs.geos ];

  # Standard configurePhase from `buildPythonPackage` seems to break the setup.py script
  configurePhase = ''
    export GEOS_DIR=${pkgs.geos}
  '';

  # The 'check' target is not supported by the `setup.py` script.
  # TODO : do the post install checks (`cd examples && ${python.interpreter} run_all.py`)
  doCheck = false;

  meta = with lib; {
    homepage = "https://matplotlib.org/basemap/";
    description = "Plot data on map projections with matplotlib";
    longDescription = ''
      An add-on toolkit for matplotlib that lets you plot data on map projections with
      coastlines, lakes, rivers and political boundaries. See
      http://matplotlib.github.com/basemap/users/examples.html for examples of what it can do.
    '';
    license = with licenses; [ mit gpl2 ];
    broken = pythonAtLeast "3.9";
  };

}
