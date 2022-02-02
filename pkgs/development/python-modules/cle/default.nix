{ lib
, buildPythonPackage
, cffi
, fetchFromGitHub
, minidump
, nose
, pefile
, pyelftools
, pytestCheckHook
, pythonOlder
, pyvex
, pyxbe
, sortedcontainers
}:

let
  # The binaries are following the argr projects release cycle
  version = "9.1.11752";

  # Binary files from https://github.com/angr/binaries (only used for testing and only here)
  binaries = fetchFromGitHub {
    owner = "angr";
    repo = "binaries";
    rev = "v${version}";
    sha256 = "1qlrxfj1n34xvwkac6mbcc7zmixxbp34fj7lkf0fvp7zcz1rpla1";
  };

in
buildPythonPackage rec {
  pname = "cle";
  inherit version;
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pnbFnv/te7U2jB6gNRvE9DQssBkFsara1g6Gtqf+WVo=";
  };

  propagatedBuildInputs = [
    cffi
    minidump
    pefile
    pyelftools
    pyvex
    pyxbe
    sortedcontainers
  ];

  checkInputs = [
    nose
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
    # Binary not found, seems to be missing in the current binaries release
    "test_plt_full_relro"
    # Test fails
    "test_tls_pe_incorrect_tls_data_start"
  ];

  pythonImportsCheck = [
    "cle"
  ];

  meta = with lib; {
    description = "Python loader for many binary formats";
    homepage = "https://github.com/angr/cle";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
