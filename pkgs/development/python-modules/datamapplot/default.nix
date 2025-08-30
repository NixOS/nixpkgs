{
  buildPythonPackage,
  colorcet,
  colorspacious,
  dask,
  datashader,
  fetchFromGitHub,
  importlib-resources,
  jinja2,
  lib,
  matplotlib,
  numba,
  numpy,
  platformdirs,
  pyarrow,
  pylabeladjust,
  rcssmin,
  requests,
  rjsmin,
  scikit-image,
  scikit-learn,
  setuptools,
  typing-extensions,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "datamapplot";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TutteInstitute";
    repo = "datamapplot";
    tag = "release-${version}";
    hash = "sha256-C3quac3gW3X/I3pPwaK2svK8qvmzMkgy/bgRqREH9VA=";
  };

  pythonRelaxDeps = [ "dask" ];

  build-system = [ setuptools ];

  dependencies = [
    colorcet
    colorspacious
    dask
    datashader
    importlib-resources
    jinja2
    matplotlib
    numba
    numpy
    pyarrow
    pylabeladjust
    requests
    rcssmin
    rjsmin
    scikit-image
    scikit-learn
    platformdirs
    typing-extensions
  ]
  ++ dask.optional-dependencies.complete;

  pythonImportsCheck = [ "datamapplot" ];

  nativeCheckInputs = [
    # numba caches some compiled functions in the home dir
    # See https://github.com/numba/numba/issues/4032#issuecomment-488102702
    writableTmpDirAsHomeHook
    pytestCheckHook
  ];

  disabledTests = [
    # network access
    "test_plot_wikipedia"

    # requires package to be installed (i.e. pip install -e .)
    # to be able to execute dmp_offline_cache from console_scripts defined in setup.cfg
    "test_import_no_clobber"
    "test_import_clobber_partial"
    "test_import_no_confirm"
    "test_export_no_clobber"
    "test_export_clobber_partial"
    "test_export_no_confirm"
    "test_bail_stdin_closed"
  ];

  meta = {
    changelog = "https://github.com/TutteInstitute/datamapplot/releases/tag/release-${version}";
    description = "Library for presentation and publication ready plots of data maps";
    homepage = "https://github.com/TutteInstitute/datamapplot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hendrikheil ];
    mainProgram = "dmp_offline_cache";
  };
}
