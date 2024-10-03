{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
}:

buildPythonPackage rec {
  pname = "esp-idf-nvs-partition-gen";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf-nvs-partition-gen";
    # has no tags, so use commit "ci: Fix release PyPI GitHub action and bump version"
    rev = "251d2166ae5dcc95c369ade77b5f6459b657e620";
    hash = "sha256-fFNqv3AJPthKfnvHC2Rt0lpVTYqY06z6RjHu0bREKY8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ cryptography ];

  pythonImportsCheck = [ "esp_idf_nvs_partition_gen" ];

  meta = {
    description = "NVS Partition Generator tool";
    homepage = "https://github.com/espressif/esp-idf-nvs-partition-gen";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
