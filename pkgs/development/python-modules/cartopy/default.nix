{ buildPythonPackage, lib, fetchPypi
, pytestCheckHook, filelock, mock, pep8
, cython
, six, pyshp, shapely, geos, numpy
, gdal, pillow, matplotlib, pyepsg, pykdtree, scipy, owslib, fiona
, proj, flufl_lock
}:

buildPythonPackage rec {
  pname = "cartopy";
  version = "0.19.0.post1";

  src = fetchPypi {
    inherit version;
    pname = "Cartopy";
    sha256 = "0xnm8z3as3hriivdfd26s6vn5b63gb46x6vxw6gh1mwfm5rlg2sb";
  };

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
