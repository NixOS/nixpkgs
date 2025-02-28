{
  cudaPackages,
  lib,
  writeGpuTestPython,
  # Configuration flags
  openCVFirst,
  useOpenCVDefaultCuda,
  useTorchDefaultCuda,
}:
let
  inherit (lib.strings) optionalString;

  openCVBlock = ''

    import cv2
    print("OpenCV version:", cv2.__version__)

    # Ensure OpenCV can access the GPU.
    assert cv2.cuda.getCudaEnabledDeviceCount() > 0, "No CUDA devices found for OpenCV"
    print("OpenCV CUDA device:", cv2.cuda.printCudaDeviceInfo(cv2.cuda.getDevice()))

    # Ensure OpenCV can access the GPU.
    print(cv2.getBuildInformation())

    a = cv2.cuda.GpuMat(size=(256, 256), type=cv2.CV_32S, s=1)
    b = cv2.cuda.GpuMat(size=(256, 256), type=cv2.CV_32S, s=1)
    c = int(cv2.cuda.sum(cv2.cuda.add(a, b))[0]) # OpenCV returns a Scalar float object.

    assert c == 2 * 256 * 256, f"Expected {2 * 256 * 256} OpenCV, got {c}"

  '';

  torchBlock = ''

    import torch
    print("Torch version:", torch.__version__)

    # Set up the GPU.
    torch.cuda.init()
    # Ensure the GPU is available.
    assert torch.cuda.is_available(), "CUDA is not available to Torch"
    print("Torch CUDA device:", torch.cuda.get_device_properties(torch.cuda.current_device()))

    a = torch.ones(256, 256, dtype=torch.int32).cuda()
    b = torch.ones(256, 256, dtype=torch.int32).cuda()
    c = (a + b).sum().item()
    assert c == 2 * 256 * 256, f"Expected {2 * 256 * 256} for Torch, got {c}"

  '';

  content = if openCVFirst then openCVBlock + torchBlock else torchBlock + openCVBlock;

  torchName = "torch" + optionalString useTorchDefaultCuda "-with-default-cuda";
  openCVName = "opencv4" + optionalString useOpenCVDefaultCuda "-with-default-cuda";
in
# TODO: Ensure the expected CUDA libraries are loaded.
# TODO: Ensure GPU access works as expected.
writeGpuTestPython {
  name = if openCVFirst then "${openCVName}-then-${torchName}" else "${torchName}-then-${openCVName}";
  libraries =
    # NOTE: These are purposefully in this order.
    pythonPackages:
    let
      effectiveOpenCV = pythonPackages.opencv4.override (prevAttrs: {
        cudaPackages = if useOpenCVDefaultCuda then prevAttrs.cudaPackages else cudaPackages;
      });
      effectiveTorch = pythonPackages.torchWithCuda.override (prevAttrs: {
        cudaPackages = if useTorchDefaultCuda then prevAttrs.cudaPackages else cudaPackages;
      });
    in
    if openCVFirst then
      [
        effectiveOpenCV
        effectiveTorch
      ]
    else
      [
        effectiveTorch
        effectiveOpenCV
      ];
} content
