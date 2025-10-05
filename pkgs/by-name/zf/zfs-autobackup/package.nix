{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "zfs-autobackup";
  version = "3.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "zfs_autobackup";
    hash = "sha256-nAc1mdrtIEmUS0uMqOdvV07xP02MFj6F5uCTiCXtnMs=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ colorama ];

  pythonRemoveDeps = [ "argparse" ];

  # tests need zfs filesystem
  doCheck = false;

  pythonImportsCheck = [ "zfs_autobackup" ];

  meta = {
    description = "ZFS backup, replicationand snapshot tool";
    homepage = "https://github.com/psy0rz/zfs_autobackup";
    changelog = "https://github.com/psy0rz/zfs_autobackup/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
}
