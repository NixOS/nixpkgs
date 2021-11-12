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
, pytestCheckHook
}:

let
  installedPackageRoot = "${builtins.placeholder "out"}/${python.sitePackages}";
in buildPythonPackage rec {
  pname = "scikit-image";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0a2h3bw5rkk23k4r04qc9maccg00nddssd7lfsps8nhp5agk1vyh";
  };

  patches = [ ./add-testing-data.patch ];

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

  checkInputs = [ pytestCheckHook ];

  # (1) The package has cythonized modules, whose .so libs will appear only in the wheel, i.e. in nix store;
  # (2) To stop Python from importing the wrong directory, i.e. the one in the build dir, not the one in nix store, `skimage` dir should be removed or renamed;
  # (3) Therefore, tests should be run on the installed package in nix store.

  # See e.g. https://discourse.nixos.org/t/cant-import-cythonized-modules-at-checkphase/14207 on why the following is needed.
  preCheck = ''
    rm -r skimage
  '';

  disabledTestPaths = [
    # Requires network access (actually some data is loaded via `skimage._shared.testing.fetch` in the global scope, which calls `pytest.skip` when a network is unaccessible, leading to a pytest collection error).
    "${installedPackageRoot}/skimage/filters/rank/tests/test_rank.py"
  ];
  pytestFlagsArray = [ "${installedPackageRoot}" "--pyargs" "skimage" ] ++ builtins.map (testid: "--deselect=" + testid) [
    # These tests require network access
    "skimage/data/test_data.py::test_skin"
    "skimage/data/tests/test_data.py::test_skin"
    "skimage/io/tests/test_io.py::test_imread_http_url"
    "skimage/restoration/tests/test_rolling_ball.py::test_ndim"
  ];

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
