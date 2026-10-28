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
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cle";
  # Keep angr-management, angr, archinfo, cle, and pyvex in sync.
  # nixpkgs-update: no auto update
  version = "10.0.4";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "cle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SjPIjxB7JdWn734FaeRw3ytv8Qc86DD0t7wuWiUxnQ8=";
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

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck =
    let
      binaries = fetchFromGitHub {
        owner = "angr";
        repo = "binaries";
        tag = "v${finalAttrs.version}";
        hash = "sha256-EfmNEokXDCbiBpxQLhM1XG2hI/+n+QIFS3eNlEMdbe4=";
      };
    in
    ''
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
    maintainers = with lib.maintainers; [
      connornelson
      fab
    ];
  };
})
