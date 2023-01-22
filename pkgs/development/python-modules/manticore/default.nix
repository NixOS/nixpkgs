{ lib
, buildPythonPackage
, capstone
, crytic-compile
, fetchFromGitHub
, intervaltree
, ply
, prettytable
, protobuf
, pyelftools
, pyevmasm
, pysha3
, pytestCheckHook
, pythonOlder
, pyyaml
, rlp
, stdenv
, unicorn
, wasm
, yices
, z3
}:

buildPythonPackage rec {
  pname = "manticore";
  version = "0.3.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "manticore";
    rev = version;
    hash = "sha256-+17VBfAtkZZIi3SF5Num1Uqg3WjIpgbz3Jx65rD5zkM=";
  };

  propagatedBuildInputs = [
    crytic-compile
    intervaltree
    ply
    prettytable
    protobuf
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

  postPatch = ''
    # Python API is not used in the code, only z3 from PATH
    substituteInPlace setup.py \
      --replace "z3-solver" "" \
      --replace "crytic-compile==0.2.2" "crytic-compile>=0.2.2"
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export PATH=${yices}/bin:${z3}/bin:$PATH
  '';

  disabledTestPaths = [
    "tests/ethereum" # Enable when solc works again
    "tests/ethereum_bench"
  ] ++ lib.optionals (!stdenv.isLinux) [
    "tests/native"
    "tests/other/test_locking.py"
    "tests/other/test_state_introspection.py"
  ];

  disabledTests = [
    # Failing tests
    "test_chmod"
    "test_timeout"
    "test_wasm_main"
    # Slow tests
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
    # Tests are failing with latest unicorn
    "Aarch64UnicornInstructions"
    "test_integration_resume"
  ];

  pythonImportsCheck = [
    "manticore"
  ];

  meta = with lib; {
    # m.c.manticore:WARNING: Manticore is only supported on Linux. Proceed at your own risk!
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Symbolic execution tool for analysis of smart contracts and binaries";
    homepage = "https://github.com/trailofbits/manticore";
    changelog = "https://github.com/trailofbits/manticore/releases/tag/${version}";
    license = licenses.agpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ arturcygan ];
  };
}
