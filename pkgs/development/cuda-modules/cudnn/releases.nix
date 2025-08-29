# NOTE: Check the following URLs for support matrices:
#       v8 -> https://docs.nvidia.com/deeplearning/cudnn/archives/index.html
#       v9 -> https://docs.nvidia.com/deeplearning/cudnn/frontend/latest/reference/support-matrix.html
# Version policy is to keep the latest minor release for each major release.
#             https://developer.download.nvidia.com/compute/cudnn/redist/
{
  cudnn.releases = {
    # jetson
    linux-aarch64 = [
      {
        version = "8.9.5.30";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-aarch64/cudnn-linux-aarch64-8.9.5.30_cuda12-archive.tar.xz";
        hash = "sha256-BJH3sC9VwiB362eL8xTB+RdSS9UHz1tlgjm/mKRyM6E=";
      }
      {
        version = "9.7.1.26";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-aarch64/cudnn-linux-aarch64-9.7.1.26_cuda12-archive.tar.xz";
        hash = "sha256-jDPWAXKOiJYpblPwg5FUSh7F0Dgg59LLnd+pX9y7r1w=";
      }
      {
        version = "9.8.0.87";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-aarch64/cudnn-linux-aarch64-9.8.0.87_cuda12-archive.tar.xz";
        hash = "sha256-8D7OP/B9FxnwYhiXOoeXzsG+OHzDF7qrW7EY3JiBmec=";
      }
    ];
    # powerpc
    linux-ppc64le = [ ];
    # server-grade arm
    linux-sbsa = [
      {
        version = "8.9.7.29";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-8.9.7.29_cuda12-archive.tar.xz";
        hash = "sha256-6Yt8gAEHheXVygHuTOm1sMjHNYfqb4ZIvjTT+NHUe9E=";
      }
      {
        version = "9.3.0.75";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.6";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-9.3.0.75_cuda12-archive.tar.xz";
        hash = "sha256-Eibdm5iciYY4VSlj0ACjz7uKCgy5uvjLCear137X1jk=";
      }
      {
        version = "9.7.1.26";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-9.7.1.26_cuda12-archive.tar.xz";
        hash = "sha256-koJFUKlesnWwbJCZhBDhLOBRQOBQjwkFZExlTJ7Xp2Q=";
      }
      {
        version = "9.8.0.87";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-9.8.0.87_cuda12-archive.tar.xz";
        hash = "sha256-IvYvR08MuzW+9UCtsdhB2mPJzT33azxOQwEPQ2ss2Fw=";
      }
      {
        version = "9.11.0.98";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.9";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-9.11.0.98_cuda12-archive.tar.xz";
        hash = "sha256-X81kUdiKnTt/rLwASB+l4rsV8sptxvhuCysgG8QuzVY=";
      }

    ];
    # x86_64
    linux-x86_64 = [
      {
        version = "8.9.7.29";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.9.7.29_cuda12-archive.tar.xz";
        hash = "sha256-R1MzYlx+QqevPKCy91BqEG4wyTsaoAgc2cE++24h47s=";
      }
      {
        version = "9.3.0.75";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.6";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-9.3.0.75_cuda12-archive.tar.xz";
        hash = "sha256-PW7xCqBtyTOaR34rBX4IX/hQC73ueeQsfhNlXJ7/LCY=";
      }
      {
        version = "9.7.1.26";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-9.7.1.26_cuda12-archive.tar.xz";
        hash = "sha256-EJpeXGvN9Dlub2Pz+GLtLc8W7pPuA03HBKGxG98AwLE=";
      }
      {
        version = "9.8.0.87";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-9.8.0.87_cuda12-archive.tar.xz";
        hash = "sha256-MhubM7sSh0BNk9VnLTUvFv6rxLIgrGrguG5LJ/JX3PQ=";
      }
      {
        version = "9.11.0.98";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.9";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-9.11.0.98_cuda12-archive.tar.xz";
        hash = "sha256-tgyPrQH6FSHS5x7TiIe5BHjX8Hs9pJ/WirEYqf7k2kg=";
      }
    ];
  };
}
