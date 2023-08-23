{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, bleach
, bokeh
, linkify-it-py
, markdown
, markdown-it-py
, mdit-py-plugins
, pandas
, param
, pyviz-comms
, requests
, tqdm
, typing-extensions
, xyzservices

# optionals: recommended
, jupyterlab
, holoviews
, matplotlib
, pillow
, plotly

# optionals: ui
, playwright
, pytest-playwright

# tests
, aiohttp
, altair
, channels
, croniter
, datashader
, django
, fastparquet
, folium
, graphviz
, hvplot
, ipympl
, ipyvuetify
, ipywidgets
, lxml
, networkx
, pydeck
, pygraphviz
, pyinstrument
, pyvista
, scikit-image
, scikit-learn
, seaborn
, streamz
, vega_datasets
, vtk
, xarray
, xgboost
}:

buildPythonPackage rec {
  pname = "panel";
  version = "1.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = "panel";
    rev = "refs/tags/v${version}";
    hash = "sha256-5WDaahzb3wvmxdXRFx87V6kIEipckvBuqD+yINRiJKA=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace \
      'version=get_setup_version("panel"),' \
      'version="${version}",'
  '';

  nativeBuildInputs = [
    setuptools
  ];

  pythonRelaxDeps = [
    "bokeh"
  ];

  propagatedBuildInputs = [
    bleach
    bokeh
    linkify-it-py
    markdown
    markdown-it-py
    mdit-py-plugins
    pandas
    param
    pyviz-comms
    requests
    setuptools
    tqdm
    typing-extensions
    xyzservices
  ];

  passthru.optional-dependencies = {
    recommended = [
      jupyterlab
      holoviews
      matplotlib
      pillow
      plotly
    ];
    ui = [
      playwright
      pytest-playwright
    ];
  };

  pythonImportsCheck = [
    "panel"
  ];

  # infinite recursion in test dependencies (hvplot)
  doCheck = false;

  nativeCheckInputs = [
    aiohttp
    altair
    channels
    croniter
    datashader
    django
    fastparquet
    folium
    graphviz
    holoviews
    hvplot
    ipympl
    ipyvuetify
    ipywidgets
    lxml
    networkx
    plotly
    pydeck
    pygraphviz
    pyinstrument
    pyvista
    scikit-image
    scikit-learn
    seaborn
    streamz
    vega_datasets
    vtk
    xarray
    xgboost
  ];

  meta = with lib; {
    description = "A high level dashboarding library for python visualization libraries";
    homepage = "https://github.com/holoviz/panel";
    changelog = "https://github.com/holoviz/panel/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
