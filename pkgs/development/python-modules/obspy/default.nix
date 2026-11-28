{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  decorator,
  lxml,
  matplotlib,
  numpy,
  requests,
  scipy,
  sqlalchemy,

  # optional-dependencies
  cartopy,
  geographiclib,
  pyshp,

  # tests
  packaging,
  pyproj,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "obspy";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "obspy";
    repo = "obspy";
    tag = finalAttrs.version;
    hash = "sha256-qloUNgseQfHEYeRorYwigbSh5s6I4ZAuvS7sN4+wPII=";
  };

  postPatch =
    # `setup.py` and `obspy.__version__` both determine the version through `git describe` and fall
    # back to this file when that fails (which it does in the sandbox).
    ''
      echo "${finalAttrs.version}" > obspy/RELEASE-VERSION
    '';

  build-system = [ setuptools ];

  dependencies = [
    decorator
    lxml
    matplotlib
    numpy
    requests
    scipy
    setuptools
    sqlalchemy
  ];

  optional-dependencies = {
    geo = [ geographiclib ];
    imaging = [ cartopy ];
    "io.shapefile" = [ pyshp ];
  };

  pythonImportsCheck = [ "obspy" ];

  # Darwin's `strip` misdetects the binary test fixtures that start with a long run of NUL bytes
  # (`*.QBN`, some SEG-Y files) as object files and truncates them to a 24-byte stub.
  stripExclude = [ "*/tests/data/*" ];

  nativeCheckInputs = [
    packaging
    pyproj
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  preCheck =
    # The C extensions are not built in-tree, so run the test suite against the installed package.
    ''
      cd "$TMPDIR"
    '';

  # Collect from the installed package, not from the source tree.
  pytestFlags = [
    "--pyargs"
    "obspy"
  ];

  disabledTests = [
    # Require internet access (`cartopy` downloads Natural Earth map data)
    "test_combined_station_event_plot"
    "test_location_plot_global"
    "test_location_plot_local"
    "test_location_plot_ortho"
    "test_plot_farfield_without_quiver_with_maps"
  ];

  meta = {
    description = "Python framework for seismological observatories";
    homepage = "https://www.obspy.org";
    changelog = "https://github.com/obspy/obspy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.ametrine ];
  };
})
