{ stdenv
, buildPythonPackage
, fetchFromGitHub
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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "matplotlib";
    repo = "basemap";
    rev = "v${version}rel";
    sha256 = "1p3app8n65rlppkdbp1pb7fa4250kh7hi7lzdsryi2iv88np7193";
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
