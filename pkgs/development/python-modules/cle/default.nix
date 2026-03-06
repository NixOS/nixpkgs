{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build inputs
  setuptools,
  # dependencies
  archinfo,
  arpy,
  cart,
  minidump,
  pefile,
  pyelftools,
  pyvex,
  pyxbe,
  pyxdia,
  sortedcontainers,
  uefi-firmware-parser,
  # check inputs
  pytestCheckHook,
  cffi,
  pypcode,
  pytest-xdist,
  # docs
  sphinxHook,
  furo,
  myst-parser,
  sphinx-autodoc-typehints,
}:

let
  # The binaries are following the argr projects release cycle
  version = "9.2.204";

  # Binary files from https://github.com/angr/binaries (only used for testing and only here)
  binaries = fetchFromGitHub {
    owner = "angr";
    repo = "binaries";
    tag = "v${version}";
    hash = "sha256-c6weHSSGhGmjjhkotELxCXhV+ACe5ub7T28hoVWM3aE=";
  };
in
buildPythonPackage rec {
  pname = "cle";
  inherit version;
  pyproject = true;

  outputs = [
    "out"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "angr";
    repo = "cle";
    tag = "v${version}";
    hash = "sha256-1a/zbQJReCaZxP3VpBI+5RRihthkYf0jtlA6thGRozc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    archinfo
    arpy
    cart
    minidump
    pefile
    pyelftools
    pyvex
    pyxbe
    pyxdia
    sortedcontainers
    uefi-firmware-parser
  ];

  optional-dependencies = {
    pcode = [ pypcode ];
  };

  pythonRelaxDeps = [
    "arpy"
  ];

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
    cffi
    pytest-xdist
  ]
  ++ optional-dependencies.pcode;

  # Place test binaries in the right location (location is hard-coded in the tests)
  preCheck = ''
    cp -r ${binaries} $TMPDIR/binaries
  '';

  pythonImportsCheck = [ "cle" ];

  meta = {
    description = "Python loader for many binary formats";
    homepage = "https://github.com/angr/cle";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
