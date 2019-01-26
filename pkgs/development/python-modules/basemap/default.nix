{ stdenv
, buildPythonPackage
, fetchurl
, numpy
, matplotlib
, pillow
, setuptools
, pkgs
}:

buildPythonPackage rec {
  pname = "basemap";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://sourceforge/project/matplotlib/matplotlib-toolkits/basemap-1.0.7/basemap-1.0.7.tar.gz";
    sha256 = "0ca522zirj5sj10vg3fshlmgi615zy5gw2assapcj91vsvhc4zp0";
  };

  propagatedBuildInputs = [ numpy matplotlib pillow ];
  buildInputs = [ setuptools pkgs.geos pkgs.proj ];

  # Standard configurePhase from `buildPythonPackage` seems to break the setup.py script
  configurePhase = ''
    export GEOS_DIR=${pkgs.geos}
  '';

  # The 'check' target is not supported by the `setup.py` script.
  # TODO : do the post install checks (`cd examples && ${python.interpreter} run_all.py`)
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://matplotlib.org/basemap/";
    description = "Plot data on map projections with matplotlib";
    longDescription = ''
      An add-on toolkit for matplotlib that lets you plot data on map projections with
      coastlines, lakes, rivers and political boundaries. See
      http://matplotlib.github.com/basemap/users/examples.html for examples of what it can do.
    '';
    license = with licenses; [ mit gpl2 ];
  };

}
