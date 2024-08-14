{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchFromGitHub,
  pythonOlder,
  substituteAll,
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
  setuptools-git-versioning,
  xyzservices,
  beautifulsoup4,
  channels,
  click,
  colorcet,
  coverage,
  firefox,
  geckodriver,
  isort,
  json5,
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
  version = "3.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zeia3b6QDDevJaIFKuF0ttO6HvCMkf1att/XEuGEw5k=";
  };

  src_test = fetchFromGitHub {
    owner = "bokeh";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PK9iLOCcivr4oF9Riq73dzxGfxzWRk3bdrCCpRrTv5g=";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-nodejs-npmjs-paths.patch;
      node_bin = "${nodejs}/bin/node";
      npm_bin = "${nodejs}/bin/npm";
    })
  ];

  nativeBuildInputs = [
    colorama
    nodejs
    setuptools
    setuptools-git-versioning
  ];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
    channels
    click
    colorcet
    coverage
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

  propagatedBuildInputs = [
    jinja2
    contourpy
    numpy
    packaging
    pandas
    pillow
    pyyaml
    tornado
    xyzservices
  ];

  doCheck = false; # need more work
  pytestFlagsArray = "tests/test_defaults.py";
  pythonImportsCheck = [ "bokeh" ];
  preCheck = ''
    cp -rv ''${src_test}/tests/* ./tests/
  '';

  meta = {
    description = "Statistical and novel interactive HTML plots for Python";
    mainProgram = "bokeh";
    homepage = "https://github.com/bokeh/bokeh";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ orivej ];
  };
}
