{ buildPythonPackage, lib, fetchPypi
, pytest_4, filelock, mock, pep8
, cython, isPy27
, six, pyshp, shapely, geos, numpy
, gdal, pillow, matplotlib, pyepsg, pykdtree, scipy, owslib, fiona
, xvfb_run
, proj_5 # see https://github.com/SciTools/cartopy/pull/1252 for status on proj 6 support
}:

buildPythonPackage rec {
  pname = "cartopy";
  version = "0.18.0";

  src = fetchPypi {
    inherit version;
    pname = "Cartopy";
    sha256 = "0d24fk0cbp29gmkysrwq05vry13swmwi3vx3cpcy04c0ixz33ykz";
  };

  checkInputs = [ filelock mock pytest_4 pep8 ];

  # several tests require network connectivity: we disable them.
  # also py2.7's tk is over-eager in trying to open an x display,
  # so give it xvfb
  checkPhase = let
    maybeXvfbRun = lib.optionalString isPy27 "${xvfb_run}/bin/xvfb-run";
  in ''
    export HOME=$(mktemp -d)
    ${maybeXvfbRun} pytest --pyargs cartopy \
      -m "not network and not natural_earth" \
      -k "not test_nightshade_image and not background_img"
  '';

  nativeBuildInputs = [
    cython
    geos # for geos-config
    proj_5
  ];

  buildInputs = [
    geos proj_5
  ];

  propagatedBuildInputs = [
    # required
    six pyshp shapely numpy

    # optional
    gdal pillow matplotlib pyepsg pykdtree scipy fiona owslib
  ];

  meta = with lib; {
    description = "Process geospatial data to create maps and perform analyses";
    license = licenses.lgpl3;
    homepage = "https://scitools.org.uk/cartopy/docs/latest/";
    maintainers = with maintainers; [ mredaelli ];
  };

}
