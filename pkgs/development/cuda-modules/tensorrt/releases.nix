# NOTE: Check https://developer.nvidia.com/nvidia-tensorrt-8x-download
#             https://developer.nvidia.com/nvidia-tensorrt-10x-download

# Version policy is to keep the latest minor release for each major release.
{
  tensorrt.releases = {
    # jetson
    linux-aarch64 = [ ];
    # powerpc
    linux-ppc64le = [ ];
    # server-grade arm
    linux-sbsa = [
      {
        version = "10.8.0.43";
        minCudaVersion = "12.8";
        maxCudaVersion = "12.8";
        cudnnVersion = "9.7";
        filename = "TensorRT-10.8.0.43.Linux.aarch64-gnu.cuda-12.8.tar.gz";
        hash = "sha256-sB5d0sfGQyUhGdA9ku6pcCNBjpL0Wjvg0Ilulikj5Do=";
      }
      {
        version = "10.9.0.34";
        minCudaVersion = "12.8";
        maxCudaVersion = "12.8";
        cudnnVersion = "9.7";
        filename = "TensorRT-10.9.0.34.Linux.aarch64-gnu.cuda-12.8.tar.gz";
        hash = "sha256-uB7CoGf2fwgsE8rsLc71Q4W0Kp3mpOyubzGKotQZZPI=";
      }
    ];
    # x86_64
    linux-x86_64 = [
      {
        version = "10.8.0.43";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.8";
        cudnnVersion = "9.7";
        filename = "TensorRT-10.8.0.43.Linux.x86_64-gnu.cuda-12.8.tar.gz";
        hash = "sha256-V31tivU4FTQUuYZ8ZmtPZYUvwusefA6jogbl+vvH1J4=";
      }
      {
        version = "10.9.0.34";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.8";
        cudnnVersion = "9.7";
        filename = "TensorRT-10.9.0.34.Linux.x86_64-gnu.cuda-12.8.tar.gz";
        hash = "sha256-M74OYeO/F3u7yrtIkr8BPwyKxx0r5z8oA4SKOCyxQnI=";
      }
    ];
  };
}
