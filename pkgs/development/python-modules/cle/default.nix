{
  lib,
  archinfo,
  buildPythonPackage,
  cart,
  cffi,
  fetchFromGitHub,
  pefile,
  pyelftools,
  pytestCheckHook,
  pythonOlder,
  pyvex,
  setuptools,
  sortedcontainers,
}:

let
  # The binaries are following the argr projects release cycle
  version = "9.2.133";

  # Binary files from https://github.com/angr/binaries (only used for testing and only here)
  binaries = fetchFromGitHub {
    owner = "angr";
    repo = "binaries";
    rev = "refs/tags/v${version}";
    hash = "sha256-+vAD9XvqV45wf7sf+VuhTbw2gFeJra5gBptfg8r8e8U=";
  };
in
buildPythonPackage rec {
  pname = "cle";
  inherit version;
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "cle";
    rev = "refs/tags/v${version}";
    hash = "sha256-R57Qd04/xtDW7/WDcZpOhkYOBCSmBNq2Bn3BYDfjseA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    archinfo
    cart
    cffi
    pefile
    pyelftools
    pyvex
    sortedcontainers
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

  pythonImportsCheck = [ "cle" ];

  meta = with lib; {
    description = "Python loader for many binary formats";
    homepage = "https://github.com/angr/cle";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
