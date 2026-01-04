{
  buildPythonPackage,
  fetchPypi,
  lib,
  pytestCheckHook,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "developer-disk-image";
  version = "0.2.0";
  pyproject = true;

  # GitHub archive is way too large
  src = fetchPypi {
    pname = "developer_disk_image";
    inherit version;
    hash = "sha256-21aLIuwznYtWsprptCAjDq4yL+ab50zZn9Dv+w7y4o8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [ "developer_disk_image" ];

  # tests connect to github.com
  doCheck = false;

  meta = {
    changelog = "https://github.com/doronz88/DeveloperDiskImage/releases/tag/v${version}";
    description = "Download DeveloperDiskImage ans Personalized images from GitHub";
    homepage = "https://github.com/doronz88/DeveloperDiskImage";
    license = lib.licenses.gpl3Plus;
    mainProgram = "developer_disk_image";
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
