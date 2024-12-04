{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "zfs-autobackup";
  version = "3.2";

  src = fetchPypi {
    inherit version;
    pname = "zfs_autobackup";
    hash = "sha256-rvtY7fsn2K2hueAsQkaPXcwxUAgE8j+GsQFF3eJKG2o=";
  };


  propagatedBuildInputs = with python3Packages; [ colorama ];

  pythonRemoveDeps = [ "argparse" ];

  # tests need zfs filesystem
  doCheck = false;

  pythonImportsCheck = [ "zfs_autobackup" ];

  meta = with lib; {
    description = "ZFS backup, replicationand snapshot tool";
    homepage = "https://github.com/psy0rz/zfs_autobackup";
    changelog = "https://github.com/psy0rz/zfs_autobackup/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
}
