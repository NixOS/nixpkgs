{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyftdi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyspiflash";
  version = "0.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eblot";
    repo = "pyspiflash";
    tag = "v${version}";
    hash = "sha256-NXYXvGSRhsTHu10pDYaZF84+d4QyPKECpuKpmgFstg0=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyftdi ];

  # tests are not shipped with the PyPI source
  doCheck = false;

  pythonImportsCheck = [ "spiflash" ];

  meta = {
    description = "SPI data flash device drivers in Python";
    homepage = "https://github.com/eblot/pyspiflash";
    changelog = "https://github.com/eblot/pyspiflash/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
