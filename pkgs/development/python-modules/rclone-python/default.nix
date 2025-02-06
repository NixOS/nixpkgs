{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  rich,
  rclone,
}:

buildPythonPackage rec {
  pname = "rclone-python";
  version = "0.1.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Johannes11833";
    repo = "rclone_python";
    tag = "v${version}";
    hash = "sha256-TGSASkvlh4ku7gZ7JhKX5yEKgSZp5VDyNz962gG6Lk0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    rclone
    rich
  ];

  # tests require working internet connection
  doCheck = false;

  pythonImportsCheck = [ "rclone_python" ];

  meta = {
    changelog = "https://github.com/Johannes11833/rclone_python/releases/tag/${src.tag}";
    description = "Python wrapper for rclone";
    homepage = "https://github.com/Johannes11833/rclone_python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CaptainJawZ ];
  };
}
