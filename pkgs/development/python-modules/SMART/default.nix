{
  buildPythonPackage,
  easydict,
  fetchFromGitHub,
  fetchpatch,
  lib,
  numpy,
  pandas,
  pytorch-lightning,
  scipy,
  setuptools,
  torch-cluster,
  torch-geometric,
  torch-scatter,
  torch,
  tqdm,
}:

buildPythonPackage {
  pname = "SMART";
  version = "unstable-2025-03-05";
  src = fetchFromGitHub {
    owner = "rainmaker22";
    repo = "SMART";
    rev = "aaf1213ebabd50bb9e280c82cbd78912650d5d0f";
    hash = "sha256-M6AfP9uPNgU6BZT96niA6kgmz9CO6doCLF5rUxfdLdM=";
  };
  pyproject = true;

  patches = [
    (fetchpatch {
      name = "fix-pyproject-toml.patch";
      url = "https://github.com/rainmaker22/SMART/commit/e84dadcc88193c8a3a7faf493af0ccc2a6755229.patch";
      hash = "sha256-4XEPxA1usBfUX4Sf2pAnszqw/hybNGhI2wd5eYJYqFA=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    easydict
    numpy
    pandas
    pytorch-lightning
    scipy
    torch
    torch-cluster
    torch-geometric
    torch-scatter
    tqdm
  ];

  meta = with lib; {
    description = "SMART: Scalable Multi-agent Real-time Motion Generation via Next-token Prediction";
    homepage = "https://github.com/rainmaker22/SMART";
    license = licenses.asl20;
  };
}
