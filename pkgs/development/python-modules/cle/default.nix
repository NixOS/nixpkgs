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
, setuptools
, sortedcontainers
}:

let
  # The binaries are following the argr projects release cycle
<<<<<<< HEAD
  version = "9.2.66";
=======
  version = "9.2.50";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Binary files from https://github.com/angr/binaries (only used for testing and only here)
  binaries = fetchFromGitHub {
    owner = "angr";
    repo = "binaries";
    rev = "refs/tags/v${version}";
    hash = "sha256-03DyvPht4E4uysKqgyfu8hxu1qh+YzWsTI09E4ftiSs=";
  };

in
buildPythonPackage rec {
  pname = "cle";
  inherit version;
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-/LDVpw1Ej2YuzwA2qUoZv/ajQZPL9dDvvawj9r5bGbo=";
=======
    hash = "sha256-pThCJlxx2IkLJhc+U5H6fSQy8QLFQr6cIILsdlEA8wM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cffi
    minidump
    pefile
    pyelftools
    pyvex
    pyxbe
    sortedcontainers
  ];

  nativeCheckInputs = [
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
    "test_plt_full_relro"
    # Test fails
    "test_tls_pe_incorrect_tls_data_start"
<<<<<<< HEAD
    "test_x86"
    "test_x86_64"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # The required parts is not present on Nix
    "test_remote_file_map"
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
