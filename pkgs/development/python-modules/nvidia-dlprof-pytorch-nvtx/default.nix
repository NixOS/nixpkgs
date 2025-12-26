{
  lib,
  buildPythonPackage,
  fetchurl,
  pythonOlder,
  numpy,
  torch,
}:

buildPythonPackage rec {
  pname = "nvidia-dlprof-pytorch-nvtx";
  version = "1.8.0";

  src = fetchurl {
    url = "https://pypi.nvidia.com/nvidia-dlprof-pytorch-nvtx/nvidia_dlprof_pytorch_nvtx-${version}-py3-none-any.whl";
    hash = "sha256-IHVCXnkVy3lXw22ISpeMdt5T7UZSzHp8sbWGF/emwGw=";
  };

  format = "wheel";

  dontBuild = true;

  dependencies = [
    numpy
    torch
  ];

  pythonImportsCheck = [
    "nvidia_dlprof_pytorch_nvtx"
  ];

  meta = {
    description = "NVIDIA DLProf Pytorch NVTX markers";
    homepage = "https://docs.nvidia.com/deeplearning/frameworks/dlprof-user-guide/index.html";
    license = lib.licenses.unfree; # NVIDIA Proprietary Software
    maintainers = with lib.maintainers; [ jherland ];
  };
}
