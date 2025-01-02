{
  lib,
  python3Packages,
  fetchFromGitHub,
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

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    click
    stringcase
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    hypothesis
    pytest-cov-stub
  ];

  doCheck = true;

  meta = {
    description = "ZFS Snapshot Replication";
    homepage = "https://github.com/alunduil/zfs-replicate";
    changelog = "https://github.com/alunduil/zfs-replicate/blob/v${version}/CHANGELOG.md";
    mainProgram = "zfs-replicate";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ alunduil ];
  };
}
