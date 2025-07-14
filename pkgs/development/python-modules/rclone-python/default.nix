{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  setuptools,
  rich,
  rclone,
}:

buildPythonPackage rec {
  pname = "rclone-python";
  version = "0.1.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Johannes11833";
    repo = "rclone_python";
    tag = "v${version}";
    hash = "sha256-vvsiXS3uI0TcL+X8+75BQmycrF+EGIgQE1dmGef35rI=";
  };

  patches = [
    (replaceVars ./hardcode-rclone-path.patch {
      rclone = lib.getExe rclone;
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
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
