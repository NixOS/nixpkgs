{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fastcore";
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastcore";
    tag = version;
    hash = "sha256-78zqQ8M0XZ6QcaH+6gw4IJDLk9d1WxjPiCr6puY/srM=";
  };

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fastcore" ];

  meta = {
    description = "Python module for Fast AI";
    homepage = "https://github.com/fastai/fastcore";
    changelog = "https://github.com/fastai/fastcore/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
