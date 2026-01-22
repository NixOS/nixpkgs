{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  lz4,
}:

python3Packages.buildPythonApplication rec {
  pname = "zfs_replicate";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alunduil";
    repo = "zfs-replicate";
    tag = "v${version}";
    hash = "sha256-VajMSoFZ4SQXpuF1Lo6S9IhxvspCfUwpNw5zg16uA3M=";
  };

  # For compression to work, both local and remote systems must have lz4 installed.
  # This hard codes the path to the lz4 binary when running it on the local system.
  postPatch = ''
    substituteInPlace zfs/replicate/compress/command.py \
      --replace-fail \
        '("/usr/bin/env - lz4 | ", "/usr/bin/env - lz4 -d | ")' \
        '("${lib.getExe lz4}  | ", "/usr/bin/env - lz4 -d | ")'
  '';

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    click
    stringcase
  ];

  nativeCheckInputs = with python3Packages; [
    hypothesis
    pytest-cov-stub
    pytestCheckHook
  ];

  doCheck = true;

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: Expected SystemExit or FileNotFoundError
    "zfs_test/replicate_test/cli_test/main_test.py"
  ];

  meta = {
    description = "ZFS Snapshot Replication";
    homepage = "https://github.com/alunduil/zfs-replicate";
    changelog = "https://github.com/alunduil/zfs-replicate/blob/v${version}/CHANGELOG.md";
    mainProgram = "zfs-replicate";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ alunduil ];
  };
}
