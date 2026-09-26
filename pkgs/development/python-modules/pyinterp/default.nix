{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # buildInputs
  boost,
  blas,
  eigen,
  gtest,
  pybind11,

  # build-system
  cmake,
  setuptools,

  # dependencies
  dask,
  numpy,
  xarray,

  # tests
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "pyinterp";
  version = "2025.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CNES";
    repo = "pangeo-pyinterp";
    tag = version;
    hash = "sha256-9DZIPiqt0JbadeGIkVrg+XuPu4XfVlHm36sBKZ2G7ww=";
  };

  # Remove the git submodule link to pybind11, patch setup.py build backend and version information
  postPatch = ''
    rm -rf third_party/pybind11
    mkdir -p third_party
    ln -sr ${pybind11.src} third_party/pybind11

    substituteInPlace pyproject.toml --replace-fail 'build-backend = "backend"' 'build-backend = "setuptools.build_meta"'
    substituteInPlace pyproject.toml --replace-fail 'backend-path = ["_custom_build"]' ""

    substituteInPlace setup.py \
      --replace-fail 'version=revision(),' 'version="${version}",'

    substituteInPlace src/pyinterp/__init__.py \
     --replace-fail 'from . import geodetic, geohash, version' 'from . import geodetic, geohash' \
     --replace-fail '__version__ = version.release()' '__version__ = "${version}"' \
     --replace-fail '__date__ = version.date()' '__date__ = "${version}"' \
     --replace-fail 'del version' ""
  '';

  dontUseCmakeConfigure = true;

  buildInputs = [
    blas
    boost
    eigen
    gtest
    pybind11
  ];

  build-system = [
    cmake
    setuptools
  ];

  dependencies = [
    dask
    numpy
    xarray
  ];

  pythonImportsCheck = [
    "pyinterp"
    "pyinterp.geohash"
  ];

  disabledTests = [
    # segmentation fault
    "test_bounding_box"
    "test_geohash"
    "test_encoding"
    "test_neighbors"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # AssertionError, probably floating point precision differences
    "test_quadrivariate"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python library for optimized geo-referenced interpolation";
    homepage = "https://github.com/CNES/pangeo-pyinterp";
    changelog = "https://github.com/CNES/pangeo-pyinterp/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
}
