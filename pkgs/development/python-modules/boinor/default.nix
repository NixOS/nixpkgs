{
  lib,
  httpx,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  astropy,
  astroquery,
  jplephem,
  matplotlib,
  numba,
  numpy,
  notebook,
  ipywidgets,
  pandas,
  ipython,
  plotly,
  pyerfa,
  scipy,
  flit-core,
  wheel,
  jupyter-client,
  jupytext,
  jupyter,
  myst-parser,
  nbsphinx,
  nbconvert,
  sgp4,
  sphinx,
  sphinx-autoapi,
  sphinx-rtd-theme,
  sphinx-hoverxref,
  sphinx-notfound-page,
  sphinx-copybutton,
  sphinxcontrib-bibtex,
  coverage,
  hypothesis,
  mypy,
  pre-commit,
  pytest_7,
  pytest-cov,
  pytest-doctestplus,
  pytest-mpl,
  pytest-mypy,
  pytest-remotedata,
  pytest-xdist,
  pytest-benchmark,
  tox,
  vulture,
}:
buildPythonPackage {
  pname = "boinor";
  version = "0.19.0-unstable-2025-12-27";
  pyproject = true;

  #NOTE: doesnt work on 3.10 due to nixpkgs numpy
  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "boinor";
    repo = "boinor";
    rev = "8e89b601b9d394a815562884c6fd39228d2b9f24";
    hash = "sha256-FqoT0Zuff5MNiIYDwMRqULZqs31Mq57ZJCI9uzmEypM=";
  };

  build-system = [
    flit-core
    numpy
    wheel
  ];

  #NOTE: plotly<7
  dependencies = [
    astropy
    astroquery
    jplephem
    matplotlib
    numba
    numpy
    pandas
    plotly
    pyerfa
    scipy
  ];

  # using like https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/astropy/default.nix#L89
  optional-dependencies = lib.fix (self: {
    #NOTE: not in nixpkgs?
    # cesium = [
    #   czml3 # ~=0.5.3
    # ];
    jupyter = [
      notebook
      ipywidgets
    ];
    doc = [
      httpx
      ipython
      ipywidgets
      jupyter-client
      jupytext
      jupyter
      myst-parser # NOTE: #>=0.13.1,<1.0.0", wrong version in nixpkgs?
      nbsphinx
      nbconvert
      sgp4
      sphinx # <9.0
      sphinx-autoapi
      # sphinx-gallery #NOTE: missing in nixpkgs
      sphinx-rtd-theme # NOTE: ~=1.0.0, wrong in nixpkgs?
      sphinx-hoverxref # NOTE: ==0.7b1, wrong in nixpkgs?
      sphinx-notfound-page
      sphinx-copybutton
      # sphinx-github-role #NOTE: missing in nixpkgs
      sphinxcontrib-bibtex
    ];
    all = [
    ]
    ++ self.jupyter
    ++ self.doc;
  });

  nativeCheckInputs = [
    coverage
    hypothesis
    # import-linter[toml] #NOTE: missing in nixpkgs?
    # interrogate #NOTE: missing in nixpkgs?
    mypy
    pre-commit
    pytest_7
    pytest-cov # NOTE: <2.6.0, wrong version in nixpkgs
    pytest-doctestplus
    pytest-mpl
    pytest-mypy
    pytest-remotedata
    pytest-xdist
    # pytest-timestamps # NOTE: missing in nixpkgs
    pytest-benchmark
    tox
    vulture
  ];

  disabledTests = [
    "test_planetary_fixed" # NOTE: fails. maybe open issue upstream
  ];

  meta = {
    homepage = "https://github.com/boinor/boinor";
    description = "Open source pure Python library for interactive Astrodynamics and Orbital Mechanics";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ petingoso ];
  };
}
