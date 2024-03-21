{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cmake
, pybind11
, setuptools
, wheel
, typing-extensions
, dm-tree
, jax
, pandas
, tabulate
, termcolor
, torch
, torchvision
, docutils
, numpy
, sphinx
, sphinx-autoapi
, sphinx-autobuild
, sphinx-autodoc-typehints
, sphinx-copybutton
, sphinx-rtd-theme
, sphinxcontrib-bibtex
, pre-commit
, pydocstyle
, pyenchant
, pylint
, ruff
, xdoctest
, pytest
, pytest-cov
, pytest-xdist
}:

buildPythonPackage rec {
  pname = "optree";
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "metaopt";
    repo = "optree";
    rev = "refs/tags/v${version}";
    hash = "sha256-T0d9P0N3hN6NRCzu1AcjHWf5kdROC1CVzoV6dqakfOA=";
  };

  nativeBuildInputs = [
    cmake
    pybind11
    setuptools
    wheel
  ];

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    typing-extensions
  ];

  passthru.optional-dependencies = {
    benchmark = [
      dm-tree
      jax
      pandas
      tabulate
      termcolor
      torch
      torchvision
    ];
    docs = [
      docutils
      jax
      numpy
      sphinx
      sphinx-autoapi
      sphinx-autobuild
      sphinx-autodoc-typehints
      sphinx-copybutton
      sphinx-rtd-theme
      sphinxcontrib-bibtex
      torch
    ];
    jax = [
      jax
    ];
    numpy = [
      numpy
    ];
    test = [
      pytest
      pytest-cov
      pytest-xdist
    ];
    torch = [
      torch
    ];
  };

  pythonImportsCheck = [
    "optree"
  ];

  meta = with lib; {
    description = "OpTree: Optimized PyTree Utilities";
    homepage = "https://github.com/metaopt/optree";
    changelog = "https://github.com/metaopt/optree/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
