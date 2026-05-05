{
  stdenv,
  fetchpatch,
  lib,
  archinfo,
  buildPythonPackage,
  cart,
  cffi,
  fetchFromGitHub,
  pefile,
  pyelftools,
  pytestCheckHook,
  pyvex,
  setuptools,
  sortedcontainers,
  nix-update-script,
  arpy,
  minidump,
  pyxbe,
  pyxdia,
  uefi-firmware-parser,
}:

let
  # The binaries are following the argr projects release cycle
  version = "9.2.197";

  # Binary files from https://github.com/angr/binaries (only used for testing and only here)
  binaries = fetchFromGitHub {
    owner = "angr";
    repo = "binaries";
    tag = "v${version}";
    hash = "sha256-x5Ot4UlJelvYANQc8h0O6FlMEEKtdWDrrQ1ku1cwey4=";
  };
in
buildPythonPackage rec {
  pname = "cle";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "cle";
    tag = "v${version}";
    hash = "sha256-8hA4r1y5tItyWPGJCMQnmLx1fRfEGjmGH86x+9WqSRQ=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    (fetchpatch {
      url = "https://github.com/angr/cle/commit/6d41df8b0d2523b5a6c1e7c80a0be9d439c72642.patch";
      hash = "sha256-c+I0jxlKsoPFX7DK/icZ+3QrAAQRjuXOlWdKrH5jMNw=";
      revert = true;
    })
  ];

  pythonRelaxDeps = [ "arpy" ];
  pythonRemoveDeps = lib.optionals stdenv.hostPlatform.isDarwin [ "pyxdia" ];

  build-system = [ setuptools ];

  dependencies = [
    archinfo
    cart
    cffi
    pefile
    pyelftools
    pyvex
    sortedcontainers
    arpy
    minidump
    pyxbe
    uefi-firmware-parser
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    pyxdia
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Place test binaries in the right location (location is hard-coded in the tests)
  preCheck = ''
    export HOME=$TMPDIR
    cp -r ${binaries} $HOME/binaries
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
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    "tests/test_pe.py"
  ];

  pythonImportsCheck = [ "cle" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python loader for many binary formats";
    homepage = "https://github.com/angr/cle";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
