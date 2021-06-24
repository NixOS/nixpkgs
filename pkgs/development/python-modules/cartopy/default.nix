{ buildPythonPackage, lib, fetchPypi, fetchpatch
, pytestCheckHook, filelock, mock, pep8
, cython
, six, pyshp, shapely, geos, numpy
, gdal, pillow, matplotlib, pyepsg, pykdtree, scipy, owslib, fiona
, proj
}:

buildPythonPackage rec {
  pname = "cartopy";
  version = "0.18.0";

  src = fetchPypi {
    inherit version;
    pname = "Cartopy";
    sha256 = "0d24fk0cbp29gmkysrwq05vry13swmwi3vx3cpcy04c0ixz33ykz";
  };

  patches = [
    # Fix numpy-1.20 compatibility.  Will be part of 0.19.
    (fetchpatch {
      url = "https://github.com/SciTools/cartopy/commit/e663bbbef07989a5f8484a8f36ea9c07e61d14ce.patch";
      sha256 = "061kbjgzkc3apaz6sxy00pkgy3n9dxcgps5wzj4rglb5iy86n2kq";
    })
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

  checkInputs = [ pytestCheckHook filelock mock pep8 ];

  pytestFlagsArray = [
    "--pyargs" "cartopy"
    "-m" "'not network and not natural_earth'"
  ];

  disabledTests = [
    "test_nightshade_image"
    "background_img"
  ];

  nativeBuildInputs = [
    cython
    geos # for geos-config
    proj
  ];

  meta = with lib; {
    description = "Process geospatial data to create maps and perform analyses";
    license = licenses.lgpl3;
    homepage = "https://scitools.org.uk/cartopy/docs/latest/";
    maintainers = with maintainers; [ mredaelli ];
  };
}
