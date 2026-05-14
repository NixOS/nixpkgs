{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,

  # build-system
  setuptools,

  # optional-dependencies
  lxml,
  matplotlib,
  numpy,
  pandas,
  pydot,
  pygraphviz,
  scipy,
  sympy,

  # tests
  pytest-xdist,
  pytestCheckHook,

  # reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "networkx";
  # upgrade may break sage, please test the sage build or ping @timokau on upgrade
  version = "3.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JrfDV6zMDIzeVYrUhig3KLZbapXYXuHNZrr6tMgWhQk=";
  };

  nativeBuildInputs = [ setuptools ];

  optional-dependencies = {
    default = [
      numpy
      scipy
      matplotlib
      pandas
    ];
    extra = [
      lxml
      pygraphviz
      pydot
      sympy
    ];
  };

  passthru.tests = {
    inherit sage;
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # No warnings of type (<class 'DeprecationWarning'>, <class 'PendingDeprecationWarning'>, <class 'FutureWarning'>) were emitted.
    "test_connected_raise"
  ];

  meta = {
    changelog = "https://github.com/networkx/networkx/blob/networkx-${version}/doc/release/release_${version}.rst";
    homepage = "https://networkx.github.io/";
    downloadPage = "https://github.com/networkx/networkx";
    description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
    license = lib.licenses.bsd3;
  };
}
