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
  version = "3.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ADLcHnatCXsHYm5RWEaF/0jGVIH7qq0QVmOxBGFlhno=";
  };

  src_test = fetchFromGitHub {
    owner = "bokeh";
    repo = "bokeh";
    rev = "refs/tags/${version}";
    hash = "sha256-MAv+6bwc5f+jZasRDsYTJ/ir0i1pYCuwqPMumsYWvws=";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-nodejs-npmjs-paths.patch;
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
