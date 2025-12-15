{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  replaceVars,
  colorama,
  contourpy,
  jinja2,
  numpy,
  nodejs,
  packaging,
  pandas,
  pillow,
  tornado,
  pytestCheckHook,
  pyyaml,
  setuptools,
  xyzservices,
  beautifulsoup4,
  channels,
  click,
  colorcet,
  firefox,
  geckodriver,
  isort,
  json5,
  narwhals,
  nbconvert,
  networkx,
  psutil,
  pygments,
  pygraphviz,
  pytest,
  pytest-asyncio,
  pytest-xdist,
  pytest-timeout,
  requests,
  scipy,
  selenium,
  toml,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "bokeh";
  # update together with panel which is not straightforward
  version = "3.7.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cKian3l7ED1e5q0V+3lErdoRXPDamW7Qt1z7phyxLys=";
  };

  patches = [
    (replaceVars ./hardcode-nodejs-npmjs-paths.patch {
      node_bin = "${nodejs}/bin/node";
      npm_bin = "${nodejs}/bin/npm";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    colorama
    nodejs
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
    channels
    click
    colorcet
    firefox
    geckodriver
    isort
    json5
    nbconvert
    networkx
    psutil
    pygments
    pygraphviz
    pytest
    pytest-asyncio
    pytest-xdist
    pytest-timeout
    requests
    scipy
    selenium
    toml
    typing-extensions
  ];

  dependencies = [
    jinja2
    contourpy
    numpy
    packaging
    pandas
    pillow
    pyyaml
    tornado
    xyzservices
    narwhals
  ];

  doCheck = false; # need more work

  pythonImportsCheck = [ "bokeh" ];

  meta = {
    description = "Statistical and novel interactive HTML plots for Python";
    mainProgram = "bokeh";
    homepage = "https://github.com/bokeh/bokeh";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
