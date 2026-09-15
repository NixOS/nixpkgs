{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  archinfo,
  arpy,
  cart,
  cffi,
  minidump,
  pefile,
  pyelftools,
  pyvex,
  pyxbe,
  pyxdia,
  sortedcontainers,
  uefi-firmware-parser,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # passthru
  nix-update-script,
}:

let
  # The binaries are following the argr projects release cycle
  version = "9.2.212";

  # Binary files from https://github.com/angr/binaries (only used for testing and only here)
  binaries = fetchFromGitHub {
    owner = "angr";
    repo = "binaries";
    tag = "v${version}";
    hash = "sha256-XXJBySIT3ylK1nd3suP2bq4bVSVah/1XhOmkEONbCoY=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "cle";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "cle";
    tag = "v${version}";
    hash = "sha256-TorjsiMq5femr5lGoKSOYWesd0RbWEZuA9fMwF4F3kA=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "arpy" ];

  dependencies = [
    archinfo
    arpy
    cart
    cffi
    minidump
    pefile
    pyelftools
    pyvex
    pyxbe
    pyxdia
    sortedcontainers
    uefi-firmware-parser
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # Place test binaries in the right location (location is hard-coded in the tests
  # as ../../binaries relative to the tests/ directory)
  preCheck = ''
    cp -r ${binaries} ../binaries
  '';

  disabledTests = [
    # PPC tests seems to fails
    "test_ppc_rel24_relocation"
    "test_ppc_addr16_ha_relocation"
    "test_ppc_addr16_lo_relocation"
    "test_plt_full_relro"
    # Test fails
    "test_tls_pe_incorrect_tls_data_start"
    "test_x86"
    "test_x86_64"
    # The required parts is not present on Nix
    "test_remote_file_map"
    # Missing test binaries
    "test_f_finale_extern_size_hints"
    "test_load_binary_larger_than_highest_address"
    "test_loading_incomplete_pe_file"
    "test_tls_directory_address_of_callbacks_null"
    "test_tls_x64"
  ];

  disabledTestPaths = [
    # These tests require PE/macOS test binaries not in the binaries repo
    "tests/test_macho_reloc.py"
    "tests/test_universal2.py"
    "tests/test_pe_meta_regions.py"
  ];

  pythonImportsCheck = [ "cle" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python loader for many binary formats";
    homepage = "https://github.com/angr/cle";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
