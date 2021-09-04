{ lib
, fetchFromGitHub
, buildPythonPackage
, python
, cython
, numpy
, scipy
, matplotlib
, networkx
, six
, pillow
, pywavelets
, dask
, cloudpickle
, imageio
, tifffile
, pytest
}:

buildPythonPackage rec {
  pname = "scikit-image";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0a2h3bw5rkk23k4r04qc9maccg00nddssd7lfsps8nhp5agk1vyh";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    cloudpickle
    dask
    imageio
    matplotlib
    networkx
    numpy
    pillow
    pywavelets
    scipy
    six
    tifffile
  ];

  checkInputs = [ pytest ];

  # (1) The package has cythonized modules, whose .so libs will appear only in the wheel, i.e. in nix store;
  # (2) To stop Python from importing the wrong directory, i.e. the one in the build dir, not the one in nix store, `skimage` dir should be removed or renamed;
  # (3) Therefore, tests should be run on the installed package in nix store.
  # (4) It requires setting a custom test root and form appropriate paths to ignored test modules, for which `pytestCheckHook` is insufficient.
  # Because of that, a custom checkPhase is needed along with the patch to add all the data/image files for testing, not only the "legacy" set.
  patches = [ ./add-testing-data.patch ];

  checkPhase = ''
    # Removing of `skimage` in the build dir is required to force Python to use the skimage in the `PYTHONPATH` instead of the build dir.
    rm -r skimage
    # Site-packages path for the installed package
    export INSTALL_PATH=$out/${python.sitePackages}

    # `skimage/filters/rank/tests/test_rank.py`: requires network access (actually some data is loaded via `skimage._shared.testing.fetch` in the global scope, which calls `pytest.skip` when network is unaccessible, leading to a pytest collection error).
    # `skimage/data/test_data.py::test_skin`: requires network access
    # `skimage/data/tests/test_data.py::test_skin`: --"--
    # `skimage/io/tests/test_io.py::test_imread_http_url`: --"--
    # `skimage/restoration/tests/test_rolling_ball.py::test_ndim`: --"--
    pytest $INSTALL_PATH \
      --ignore=$INSTALL_PATH/skimage/filters/rank/tests/test_rank.py \
      --deselect=skimage/data/test_data.py::test_skin \
      --deselect=skimage/data/tests/test_data.py::test_skin \
      --deselect=skimage/io/tests/test_io.py::test_imread_http_url \
      --deselect=skimage/restoration/tests/test_rolling_ball.py::test_ndim \
      --pyargs skimage
  '';

  # Check cythonized modules
  pythonImportsCheck = [
    "skimage"
    "skimage._shared"
    "skimage.draw"
    "skimage.feature"
    "skimage.restoration"
    "skimage.filters"
    "skimage.future.graph"
    "skimage.graph"
    "skimage.io"
    "skimage.measure"
    "skimage.morphology"
    "skimage.transform"
    "skimage.util"
    "skimage.segmentation"
  ];

  meta = {
    description = "Image processing routines for SciPy";
    homepage = "https://scikit-image.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
