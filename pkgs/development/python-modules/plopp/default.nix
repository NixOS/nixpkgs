{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  lazy-loader,
  matplotlib,

  # tests
  pytestCheckHook,
  anywidget,
  graphviz,
  h5py,
  ipympl,
  ipywidgets,
  mpltoolbox,
  pandas,
  plotly,
  pooch,
  pyarrow,
  pythreejs,
  scipp,
  scipy,
  xarray,

  # tests data
  symlinkJoin,
  fetchurl,
}:

buildPythonPackage (finalAttrs: {
  pname = "plopp";
  version = "26.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "plopp";
    tag = finalAttrs.version;
    hash = "sha256-JYgha+gmp9Ht6Ly9+i6dT+jdiDgsAEH5qH5MJ4n9LR8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    lazy-loader
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    anywidget
    graphviz
    h5py
    ipympl
    ipywidgets
    mpltoolbox
    pandas
    plotly
    pooch
    pyarrow
    pythreejs
    scipp
    scipy
    xarray
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # RuntimeError: There is no current event loop in thread 'MainThread'
    "test_move_cut"
    "test_value_cuts"
  ];

  env = {
    # See: https://github.com/scipp/plopp/blob/25.05.0/src/plopp/data/examples.py
    PLOPP_DATA_DIR =
      let
        # NOTE this might be changed by upstream in the future.
        _version = "1";
      in
      symlinkJoin {
        name = "plopp-test-data";
        paths =
          lib.mapAttrsToList
            (
              file: hash:
              fetchurl {
                url = "https://public.esss.dk/groups/scipp/plopp/${_version}/${file}";
                inherit hash;
                downloadToTemp = true;
                recursiveHash = true;
                postFetch = ''
                  mkdir -p $out/${_version}
                  mv $downloadedFile $out/${_version}/${file}
                '';
              }
            )
            {
              "nyc_taxi_data.h5" = "sha256-hso8ESM+uLRf4y2CW/7dpAmm/kysAfJY3b+5vz78w4Q=";
              "teapot.h5" = "sha256-i6hOw72ce1cBT6FMQTdCEKVe0WOMOjApKperGHoPW34=";
            };
      };
  };

  pythonImportsCheck = [
    "plopp"
  ];

  meta = {
    description = "Visualization library for scipp";
    homepage = "https://scipp.github.io/plopp/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
