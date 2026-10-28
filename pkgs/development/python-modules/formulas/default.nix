{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  bahttext,
  click,
  click-log,
  dictdiffer,
  ezodf,
  flask,
  lxml,
  numpy,
  numpy-financial,
  openpyxl,
  python-dateutil,
  regex,
  schedula,
  scipy,
  statsmodels,
  tqdm,

  # optional-dependencies
  docutils,
  graphviz,
  jinja2,
  pygments,

  # tests
  ddt,
  dill,
  pytestCheckHook,
  sphinx,
  sphinx-click,
  sphinx-rtd-theme,
  sphinxcontrib-restbuilder,
}:

buildPythonPackage (finalAttrs: {
  pname = "formulas";
  version = "1.3.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vinci1it2000";
    repo = "formulas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mcHGoXtZtBqZBh68/bsRDz75q1oHCMKoUUVlEsnPdNI=";
  };

  patches = [
    (fetchpatch {
      name = "linest-aarch64-blas-rounding.patch";
      url = "https://github.com/vinci1it2000/formulas/commit/2d68e59d1abb10433feefef5c7cdcab378459159.patch";
      hash = "sha256-5jnE7f2HypuFrP8g9rhWZovNw//T+vbHMfbBXhA4UmE=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    bahttext
    click
    click-log
    dictdiffer
    ezodf
    flask
    lxml
    numpy
    numpy-financial
    openpyxl
    python-dateutil
    regex
    schedula
    scipy
    statsmodels
    tqdm
  ];

  optional-dependencies =
    let
      excelDeps = [
        dictdiffer
        ezodf
        lxml
        openpyxl
      ];
    in
    {
      excel = excelDeps;
      plot = [
        docutils
        flask
        graphviz
        jinja2
        pygments
        regex
      ];
      cli = excelDeps ++ [
        click-log
        flask
      ];
    };

  nativeCheckInputs = [
    ddt
    dill
    docutils
    graphviz
    jinja2
    pygments
    pytestCheckHook
    sphinx
    sphinx-click
    sphinx-rtd-theme
    sphinxcontrib-restbuilder
  ];

  # itertools.count is not picklable on 3.14; schedula stores count().__next__
  # https://github.com/python/cpython/issues/101588
  postPatch = lib.optionalString (pythonAtLeast "3.14") ''
    cat > test/conftest.py << 'EOF'
    import copyreg
    import itertools


    def _reduce_count(_obj):
        return itertools.count, ()


    copyreg.pickle(itertools.count, _reduce_count)
    EOF
  '';

  pythonImportsCheck = [ "formulas" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Parse and compile Excel formulas and workbooks in Python code";
    homepage = "https://github.com/vinci1it2000/formulas";
    changelog = "https://github.com/vinci1it2000/formulas/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.eupl11;
    maintainers = [ lib.maintainers.lucasew ];
    teams = [ lib.teams.ngi ];
    mainProgram = "formulas";
    platforms = lib.platforms.linux;
  };
})
