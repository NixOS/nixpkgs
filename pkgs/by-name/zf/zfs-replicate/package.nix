{
  python3Packages,
  fetchPypi,
  lib,
}:

python3Packages.buildPythonApplication rec {
  pname = "zfs_replicate";
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9WD2IW7GRxMF7hOa8HTI/+cuOjVaYMT4OnrYU/xFgME=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    hypothesis
    pytest-cov-stub
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    stringcase
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/alunduil/zfs-replicate";
    description = "ZFS Snapshot Replication";
    mainProgram = "zfs-replicate";
    license = licenses.bsd2;
    maintainers = with maintainers; [ alunduil ];
  };
}
