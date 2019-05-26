{ buildPythonPackage, lib, fetchPypi
, pytest, filelock, mock, pep8
, cython, isPy27, isPy37, glibcLocales
, six, pyshp, shapely, geos, proj, numpy
, gdal, pillow, matplotlib, pyepsg, pykdtree, scipy, owslib, fiona
, xvfb_run
}:

buildPythonPackage rec {
  pname = "cartopy";
  version = "0.17.0";

  src = fetchPypi {
    inherit version;
    pname = "Cartopy";
    sha256 = "0q9ckfi37cxj7jwnqnzij62vwcf4krccx576vv5lhvpgvplxjjs2";
  };

  checkInputs = [ filelock mock pytest pep8 ];

  # several tests require network connectivity: we disable them.
  # also py2.7's tk is over-eager in trying to open an x display,
  # so give it xvfb
  checkPhase = let
    maybeXvfbRun = lib.optionalString isPy27 "${xvfb_run}/bin/xvfb-run";
  in ''
    export HOME=$(mktemp -d)
    ${maybeXvfbRun} pytest --pyargs cartopy \
      -m "not network and not natural_earth" \
      -k "not test_nightshade_image"
  '';

  nativeBuildInputs = [
    cython
    geos # for geos-config
    proj
  ];

  buildInputs = [
    geos proj
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
    homepage = https://scitools.org.uk/cartopy/docs/latest/;
    maintainers = with maintainers; [ mredaelli ];
  };

}
