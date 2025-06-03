{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  altair,
  fastapi,
  geopandas,
  kaleido,
  llmx,
  matplotlib,
  matplotlib-venn,
  networkx,
  numpy,
  pandas,
  plotly,
  plotnine,
  pydantic,
  python-multipart,
  scipy,
  seaborn,
  statsmodels,
  typer,
  uvicorn,
  wordcloud,
  peacasso,
  basemap,
  basemap-data-hires,
  geopy,
}:

buildPythonPackage rec {
  pname = "lida";
  version = "0.0.14";
  pyproject = true;

  # No releases or tags are available in https://github.com/microsoft/lida
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/az6hS8rNPxb8cDiz9SOyUBi/X48r9prJNFUnx1wPHM=";
  };

  patches = [
    # The upstream places the data path under the py file's own directory.
    # However, since `/nix/store` is read-only, we patch it to the user's home directory.
    ./rw_data.patch
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    altair
    fastapi
    geopandas
    kaleido
    llmx
    matplotlib
    matplotlib-venn
    networkx
    numpy
    pandas
    plotly
    plotnine
    pydantic
    python-multipart
    scipy
    seaborn
    statsmodels
    typer
    uvicorn
    wordcloud
  ];

  optional-dependencies = {
    infographics = [
      peacasso
    ];
    tools = [
      basemap
      basemap-data-hires
      geopy
    ];
    transformers = [
      llmx
    ];
    web = [
      fastapi
      uvicorn
    ];
  };

  # require network
  doCheck = false;

  pythonImportsCheck = [ "lida" ];

  meta = {
    description = "Automatic Generation of Visualizations and Infographics using Large Language Models";
    homepage = "https://github.com/microsoft/lida";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "lida";
  };
}
