{
  lib,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-xdist,
  setuptools,
  wheel,
  typing-extensions,
  z3-solver,
  # docs
  sphinxHook,
  furo,
  myst-parser,
  sphinx-autodoc-typehints,
}:

buildPythonPackage rec {
  pname = "claripy";
  version = "9.2.204";
  pyproject = true;

  outputs = [
    "out"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "angr";
    repo = "claripy";
    tag = "v${version}";
    hash = "sha256-Si//mgOHVsNFE/KeqxhmJ2+Nwn9mk9rAztnavBhVe6U=";
  };

  patches = [
    ./Z3_fpa_get_numeral_sign.patch
  ];

  # z3 does not provide a dist-info, so python-runtime-deps-check will fail
  pythonRemoveDeps = [ "z3-solver" ];

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    cachetools
    typing-extensions
    z3-solver
  ]
  ++ z3-solver.requiredPythonModules;

  nativeBuildInputs = [
    sphinxHook
    furo
    myst-parser
    sphinx-autodoc-typehints
  ];

  sphinxBuilders = [
    "html"
    "man"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [ "claripy" ];

  meta = {
    description = "Python abstraction layer for constraint solvers";
    homepage = "https://github.com/angr/claripy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      fab
      misaka18931
    ];
  };
}
