{ buildPythonPackage, lib, fetchPypi
, pytestCheckHook, filelock, mock, pep8
, cython
, six, pyshp, shapely, geos, numpy
, gdal, pillow, matplotlib, pyepsg, pykdtree, scipy, owslib, fiona
, proj, flufl_lock
}:

buildPythonPackage rec {
  pname = "cartopy";
  version = "0.20.1";

  src = fetchPypi {
    inherit version;
    pname = "Cartopy";
    sha256 = "91f87b130e2574547a20cd634498df97d797abd12dcfd0235bc0cdbcec8b05e3";
  };

  postPatch = ''
    # https://github.com/SciTools/cartopy/issues/1880
    substituteInPlace lib/cartopy/tests/test_crs.py \
      --replace "test_osgb(" "dont_test_osgb(" \
      --replace "test_epsg(" "dont_test_epsg("
  '';

  buildInputs = [
    geos proj
  ];

  propagatedBuildInputs = [
    # required
    six pyshp shapely numpy

    # optional
    gdal pillow matplotlib pyepsg pykdtree scipy fiona owslib
  ];

  checkInputs = [ pytestCheckHook filelock mock pep8 flufl_lock ];

  pytestFlagsArray = [
    "--pyargs" "cartopy"
    "-m" "'not network and not natural_earth'"
  ];

  disabledTests = [
    "test_nightshade_image"
    "background_img"
    "test_gridliner_labels_bbox_style"
  ];

  nativeBuildInputs = [
    cython
    geos # for geos-config
    proj
  ];

  meta = with lib; {
    description = "Process geospatial data to create maps and perform analyses";
    license = licenses.lgpl3Plus;
    homepage = "https://scitools.org.uk/cartopy/docs/latest/";
    maintainers = with maintainers; [ mredaelli ];
  };
}
