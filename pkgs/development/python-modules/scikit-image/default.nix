{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  pythonOlder,
  astropy,
  cloudpickle,
  cython,
  dask,
  imageio,
  lazy-loader,
  matplotlib,
  meson-python,
  networkx,
  numpy,
  packaging,
  pillow,
  pooch,
  pyamg,
  pytestCheckHook,
  numpydoc,
  pythran,
  pywavelets,
  scikit-learn,
  scipy,
  setuptools,
  simpleitk,
  six,
  tifffile,
  wheel,
}:

let
  installedPackageRoot = "${builtins.placeholder "out"}/${python.sitePackages}";
  self = buildPythonPackage rec {
    pname = "scikit-image";
    version = "0.22.0";
    format = "pyproject";

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "scikit-image";
      repo = "scikit-image";
      rev = "refs/tags/v${version}";
      hash = "sha256-M18y5JBPf3DR7SlJcCf82nG2MzwILg2w1AhJMzZXslg=";
    };

    postPatch = ''
      patchShebangs skimage/_build_utils/{version,cythoner}.py

      substituteInPlace pyproject.toml \
        --replace "numpy==" "numpy>="
    '';

    nativeBuildInputs = [
      cython
      meson-python
      numpy
      packaging
      pythran
      setuptools
      wheel
    ];

    propagatedBuildInputs = [
      imageio
      lazy-loader
      matplotlib
      networkx
      numpy
      packaging
      pillow
      pywavelets
      scipy
      tifffile
    ];

    passthru.optional-dependencies = {
      data = [ pooch ];
      optional = [
        astropy
        cloudpickle
        dask
        matplotlib
        pooch
        pyamg
        scikit-learn
        simpleitk
      ] ++ dask.optional-dependencies.array;
    };

    # test suite is very cpu intensive, move to passthru.tests
    doCheck = false;
    nativeCheckInputs = [
      pytestCheckHook
      numpydoc
    ];

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
    pytestFlagsArray =
      [
        "${installedPackageRoot}"
        "--pyargs"
        "skimage"
      ]
      ++ builtins.map (testid: "--deselect=" + testid) (
        [
          # These tests require network access
          "skimage/data/test_data.py::test_skin"
          "skimage/data/tests/test_data.py::test_skin"
          "skimage/io/tests/test_io.py::test_imread_http_url"
          "skimage/restoration/tests/test_rolling_ball.py::test_ndim"
        ]
        ++ lib.optionals stdenv.isDarwin [
          # Matplotlib tests are broken inside darwin sandbox
          "skimage/feature/tests/test_util.py::test_plot_matches"
          "skimage/filters/tests/test_thresholding.py::TestSimpleImage::test_try_all_threshold"
          "skimage/io/tests/test_mpl_imshow.py::"
          # See https://github.com/scikit-image/scikit-image/issues/7061 and https://github.com/scikit-image/scikit-image/issues/7104
          "skimage/measure/tests/test_fit.py"
        ]
        ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
          # https://github.com/scikit-image/scikit-image/issues/7104
          "skimage/measure/tests/test_moments.py"
        ]
      );

    # Check cythonized modules
    pythonImportsCheck = [
      "skimage"
      "skimage._shared"
      "skimage.draw"
      "skimage.feature"
      "skimage.restoration"
      "skimage.filters"
      "skimage.graph"
      "skimage.io"
      "skimage.measure"
      "skimage.morphology"
      "skimage.transform"
      "skimage.util"
      "skimage.segmentation"
    ];

    passthru.tests = {
      all-tests = self.override { doCheck = true; };
    };

    meta = {
      description = "Image processing routines for SciPy";
      homepage = "https://scikit-image.org";
      changelog = "https://github.com/scikit-image/scikit-image/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ yl3dy ];
    };
  };
in
self
