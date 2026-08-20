{
  lib,
  archinfo,
  arpy,
  buildPythonPackage,
  cart,
  fetchFromGitHub,
  minidump,
  pefile,
  pyelftools,
  pytestCheckHook,
  pyvex,
  pyxbe,
  pyxdia,
  pythonOlder,
  setuptools,
  sortedcontainers,
  uefi-firmware,
}:

let
  # Released alongside angr 9.3.3; the binaries repository was not bumped to 9.3.
  binaries = fetchFromGitHub {
    owner = "angr";
    repo = "binaries";
    tag = "v9.2.227";
    hash = "sha256-ehab3ApgaqNrSlVD1bjhB4zLhz039Mk57recam03HY0=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "cle";
  # Keep angr-management, angr, archinfo, claripy, cle, and pyvex in sync.
  # nixpkgs-update: no auto update
  version = "9.3.3";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "cle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8KLndMNdEbg2qFXgfvG4BalQnNN2pEkbTcuef+mh9Dk=";
  };

  pythonRelaxDeps = [ "arpy" ];

  # pyxdia bundles Microsoft's unfree DIA runtime, so keep PDB support opt-in.
  pythonRemoveDeps = [ "pyxdia" ];

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
    sortedcontainers
    uefi-firmware
  ];

  optional-dependencies.pdb = [ pyxdia ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME="$TMPDIR"
    ln -s ${binaries} ../binaries
  '';

  disabledTests = [
    # Require the optional unfree pyxdia dependency.
    "test_debug_symbol_paths_flat_layout"
    "test_debug_symbol_paths_multiple_paths"
    "test_debug_symbol_paths_nonexistent_path"
    "test_debug_symbol_paths_symbol_store_layout"
    "test_pdb"
  ];

  pythonImportsCheck = [ "cle" ];

  meta = {
    description = "Python loader for many binary formats";
    homepage = "https://github.com/angr/cle";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
