{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools

# optional-dependencies
, lxml
, matplotlib
, numpy
, pandas
, pydot
, pygraphviz
, scipy
, sympy

# tests
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "networkx";
  # upgrade may break sage, please test the sage build or ping @timokau on upgrade
  version = "3.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nxu1zzQJvzJOCnIsIL20wg7jm/HDDOiuSZyFArC14MY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  passthru.optional-dependencies = {
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

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/networkx/networkx/blob/networkx-${version}/doc/release/release_${version}.rst";
    homepage = "https://networkx.github.io/";
    downloadPage = "https://github.com/networkx/networkx";
    description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
    license = lib.licenses.bsd3;
  };
}
