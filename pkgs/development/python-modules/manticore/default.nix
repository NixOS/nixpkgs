{ lib
, buildPythonPackage
, fetchFromGitHub
, capstone
, crytic-compile
, ply
, prettytable
, pyelftools
, pyevmasm
, pysha3
, pyyaml
, rlp
, stdenv
, unicorn
, wasm
, yices
, pytestCheckHook
, z3
}:

buildPythonPackage rec {
  pname = "manticore";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "manticore";
    rev = version;
    sha256 = "0z2nhfcraa5dx6srbrw8s11awh2la0x7d88yw9in8g548nv6qa69";
  };

  propagatedBuildInputs = [
    crytic-compile
    ply
    prettytable
    pyevmasm
    pysha3
    pyyaml
    rlp
    wasm
  ] ++ lib.optionals (stdenv.isLinux) [
    capstone
    pyelftools
    unicorn
  ];

  # Python API is not used in the code, only z3 from PATH
  postPatch = ''
    sed -ie s/z3-solver// setup.py
  '';

  checkInputs = [ pytestCheckHook ];
  preCheck = "export PATH=${yices}/bin:${z3}/bin:$PATH";
  pytestFlagsArray = [
    "--ignore=tests/ethereum" # TODO: enable when solc works again
    "--ignore=tests/ethereum_bench"
  ] ++ lib.optionals (!stdenv.isLinux) [
    "--ignore=tests/native"
    "--ignore=tests/other/test_locking.py"
    "--ignore=tests/other/test_state_introspection.py"
  ];
  disabledTests = [
    # failing tests
    "test_chmod"
    "test_timeout"
    "test_wasm_main"
    # slow tests
    "testmprotectFailSymbReading"
    "test_ConstraintsForking"
    "test_resume"
    "test_symbolic"
    "test_symbolic_syscall_arg"
    "test_state_merging"
    "test_decree"
    "test_register_comparison"
    "test_arguments_assertions_armv7"
    "test_integration_basic_stdout"
    "test_fclose_linux_amd64"
    "test_fileio_linux_amd64"
    "test_arguments_assertions_amd64"
    "test_ioctl_bogus"
    "test_ioctl_socket"
    "test_brk_regression"
    "test_basic_arm"
    "test_logger_verbosity"
    "test_profiling_data"
    "test_integration_basic_stdin"
    "test_getchar"
    "test_ccmp_reg"
    "test_ld1_mlt_structs"
    "test_ccmp_imm"
    "test_try_to_allocate_greater_than_last_space_memory_page_12"
    "test_not_enough_memory_page_12"
    "test_PCMPISTRI_30_symbolic"
    "test_ld1_mlt_structs"
    "test_time"
    "test_implicit_call"
    "test_trace"
    "test_plugin"
  ];

  meta = with lib; {
    description = "Symbolic execution tool for analysis of smart contracts and binaries";
    homepage = "https://github.com/trailofbits/manticore";
    changelog = "https://github.com/trailofbits/manticore/releases/tag/${version}";
    license = licenses.agpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ arturcygan ];
  };
}
