{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  pythonOlder,

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
  version = "3.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1Mb5z4H1LWkjCGZ5a4KvvM3sPbeuT70bZep1D+7VADc=";
  };

  # backport patch to fix tests with Python 3.13.4
  # FIXME: remove in next update
  patches = [
    (fetchpatch {
      url = "https://github.com/networkx/networkx/commit/d85b04a8b9619580d8901f35400414f612c83113.patch";
      includes = [ "networkx/generators/lattice.py" ];
      hash = "sha256-6y/aJBDgNkUzmQ6o52CGVVzqoQgkCEXA4iAXhv1cS0c=";
    })
  ];

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
