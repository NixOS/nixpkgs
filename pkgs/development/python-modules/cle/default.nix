{
  lib,
  archinfo,
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  minidump,
  pefile,
  pyelftools,
  pynose,
  pytestCheckHook,
  pythonOlder,
  pyvex,
  pyxbe,
  setuptools,
  sortedcontainers,
}:

let
  # The binaries are following the argr projects release cycle
  version = "9.2.98";

  # Binary files from https://github.com/angr/binaries (only used for testing and only here)
  binaries = fetchFromGitHub {
    owner = "angr";
    repo = "binaries";
    rev = "refs/tags/v${version}";
    hash = "sha256-hnYMAgEnDHXg1jUrzhLWuun+Gv+2xnd4Da6OC9IGa2Q=";
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
    hash = "sha256-6gJKhyjKBgtSwGk5lqkaQVxe0ZC5WHVIYQMeREfz9A0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    archinfo
    cffi
    minidump
    pefile
    pyelftools
    pyvex
    pyxbe
    sortedcontainers
  ];

  nativeCheckInputs = [
    pynose
    pytestCheckHook
  ];

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
