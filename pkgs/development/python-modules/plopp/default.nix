{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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

buildPythonPackage rec {
  pname = "plopp";
  version = "25.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "plopp";
    tag = version;
    hash = "sha256-b9f08Wf6SGNb2rTnOqZhsSvRcfg1T+JXItZa67q2vtM=";
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
}
