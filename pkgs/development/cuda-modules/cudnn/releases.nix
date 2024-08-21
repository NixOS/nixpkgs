# NOTE: Check https://docs.nvidia.com/deeplearning/cudnn/archives/index.html for support matrices.
# Version policy is to keep the latest minor release for each major release.
{
  cudnn.releases = {
    # jetson
    linux-aarch64 = [
      {
        version = "8.9.5.30";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.2";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-aarch64/cudnn-linux-aarch64-8.9.5.30_cuda12-archive.tar.xz";
        hash = "sha256-BJH3sC9VwiB362eL8xTB+RdSS9UHz1tlgjm/mKRyM6E=";
      }
    ];
    # powerpc
    linux-ppc64le = [ ];
    # server-grade arm
    linux-sbsa = [
      {
        version = "8.4.1.50";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.7";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-8.4.1.50_cuda11.6-archive.tar.xz";
        hash = "sha256-CxufrFt4l04v2qp0hD2xj2Ns6PPZmdYv8qYVuZePw2A=";
      }
      {
        version = "8.5.0.96";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.7";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-8.5.0.96_cuda11-archive.tar.xz";
        hash = "sha256-hngKu+zUY05zY/rR0ACuI7eQWl+Dg73b9zMsaTR5Hd4=";
      }
      {
        version = "8.6.0.163";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-8.6.0.163_cuda11-archive.tar.xz";
        hash = "sha256-oCAieNPL1POtw/eBa/9gcWIcsEKwkDaYtHesrIkorAY=";
      }
      {
        version = "8.7.0.84";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-8.7.0.84_cuda11-archive.tar.xz";
        hash = "sha256-z5Z/eNv2wHUkPMg6oYdZ43DbN1SqFbEqChTov2ejqdQ=";
      }
      {
        version = "8.8.1.3";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-8.8.1.3_cuda11-archive.tar.xz";
        hash = "sha256-OzWq+aQkmIbZONmWSYyFoZzem3RldoXyJy7GVT6GM1k=";
      }
      {
        version = "8.8.1.3";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.0";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-8.8.1.3_cuda12-archive.tar.xz";
        hash = "sha256-njl3qhudBuuGC1gqyJM2MGdaAkMCnCWb/sW7VpmGfSA=";
      }
      {
        version = "8.9.7.29";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-8.9.7.29_cuda11-archive.tar.xz";
        hash = "sha256-kcN8+0WPVBQZ6YUQ8TqvWXXAIyxhPhi3djhUkAdO6hc=";
      }
      {
        version = "8.9.7.29";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.2";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-8.9.7.29_cuda12-archive.tar.xz";
        hash = "sha256-6Yt8gAEHheXVygHuTOm1sMjHNYfqb4ZIvjTT+NHUe9E=";
      }
    ];
    # x86_64
    linux-x86_64 = [
      {
        version = "7.4.2.24";
        minCudaVersion = "10.0";
        maxCudaVersion = "10.0";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v7.4.2/cudnn-10.0-linux-x64-v7.4.2.24.tgz";
        hash = "sha256-Lt/IagK1DRfojEeJVaMy5qHoF05+U6NFi06lH68C2qM=";
      }
      {
        version = "7.6.5.32";
        minCudaVersion = "10.0";
        maxCudaVersion = "10.0";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v7.6.5/cudnn-10.0-linux-x64-v7.6.5.32.tgz";
        hash = "sha256-KDVeOV8LK5OsLIO2E2CzW6bNA3fkTni+GXtrYbS0kro=";
      }
      {
        version = "7.6.5.32";
        minCudaVersion = "10.1";
        maxCudaVersion = "10.1";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v7.6.5/cudnn-10.1-linux-x64-v7.6.5.32.tgz";
        hash = "sha256-fq7IA5osMKsLx1jTA1iHZ2k972v0myJIWiwAvy4TbLM=";
      }
      {
        version = "7.6.5.32";
        minCudaVersion = "10.2";
        maxCudaVersion = "10.2";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v7.6.5/cudnn-10.2-linux-x64-v7.6.5.32.tgz";
        hash = "sha256-YAJn8squ0v1Y6yFLpmnY6jXzlqfRm5SCLms2+fcIjCA='";
      }
      {
        version = "8.0.5.39";
        minCudaVersion = "10.1";
        maxCudaVersion = "10.1";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v8.0.5/cudnn-10.1-linux-x64-v8.0.5.39.tgz";
        hash = "sha256-kJCElSmIlrM6qVBjo0cfk8NmJ9esAcF9w211xl7qSgA=";
      }
      {
        version = "8.0.5.39";
        minCudaVersion = "10.2";
        maxCudaVersion = "10.2";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v8.0.5/cudnn-10.2-linux-x64-v8.0.5.39.tgz";
        hash = "sha256-IfhMBcZ78eyFnnfDjM1b8VSWT6HDCPRJlZvkw1bjgvM=";
      }
      {
        version = "8.0.5.39";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.0";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v8.0.5/cudnn-11.0-linux-x64-v8.0.5.39.tgz";
        hash = "sha256-ThbueJXetKixwZS4ErpJWG730mkCBRQB03F1EYmKm3M=";
      }
      {
        version = "8.0.5.39";
        minCudaVersion = "11.1";
        maxCudaVersion = "11.1";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v8.0.5/cudnn-11.1-linux-x64-v8.0.5.39.tgz";
        hash = "sha256-HQRr+nk5navMb2yxUHkYdUQ5RC6gyp4Pvs3URvmwDM4=";
      }
      {
        version = "8.1.1.33";
        minCudaVersion = "10.2";
        maxCudaVersion = "10.2";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v8.1.1/cudnn-10.2-linux-x64-v8.1.1.33.tgz";
        hash = "sha256-Kkp7mabpv6aQ6xm7QeSVU/KnpJGls6v8rpAOFmxbbr0=";
      }
      {
        version = "8.1.1.33";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.2";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v8.1.1/cudnn-11.2-linux-x64-v8.1.1.33.tgz";
        hash = "sha256-mKh4TpKGLyABjSDCgbMNSgzZUfk2lPZDPM9K6cUCumo=";
      }
      {
        version = "8.2.4.15";
        minCudaVersion = "10.2";
        maxCudaVersion = "10.2";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v8.2.4/cudnn-10.2-linux-x64-v8.2.4.15.tgz";
        hash = "sha256-0jyUoxFaHHcRamwSfZF1+/WfcjNkN08mo0aZB18yIvE=";
      }
      {
        version = "8.2.4.15";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.4";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v8.2.4/cudnn-11.4-linux-x64-v8.2.4.15.tgz";
        hash = "sha256-Dl0t+JC5ln76ZhnaQhMQ2XMjVlp58FoajLm3Fluq0Nc=";
      }
      {
        version = "8.3.3.40";
        minCudaVersion = "10.2";
        maxCudaVersion = "10.2";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v8.3.3/local_installers/10.2/cudnn-linux-x86_64-8.3.3.40_cuda10.2-archive.tar.xz";
        hash = "sha256-2FVPKzLmKV1fyPOsJeaPlAWLAYyAHaucFD42gS+JJqs=";
      }
      {
        version = "8.3.3.40";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.6";
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v8.3.3/local_installers/11.5/cudnn-linux-x86_64-8.3.3.40_cuda11.5-archive.tar.xz";
        hash = "sha256-6r6Wx1zwPqT1N5iU2RTx+K4UzqsSGYnoSwg22Sf7dzE=";
      }
      {
        version = "8.4.1.50";
        minCudaVersion = "10.2";
        maxCudaVersion = "10.2";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.4.1.50_cuda10.2-archive.tar.xz";
        hash = "sha256-I88qMmU6lIiLVmaPuX7TTbisgTav839mssxUo3lQNjg=";
      }
      {
        version = "8.4.1.50";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.7";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.4.1.50_cuda11.6-archive.tar.xz";
        hash = "sha256-7JbSN22B/KQr3T1MPXBambKaBlurV/kgVhx2PinGfQE=";
      }
      {
        version = "8.5.0.96";
        minCudaVersion = "10.2";
        maxCudaVersion = "10.2";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.5.0.96_cuda10-archive.tar.xz";
        hash = "sha256-1mzhbbzR40WKkHnQLtJHhg0vYgf7G8a0OBcCwIOkJjM=";
      }
      {
        version = "8.5.0.96";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.7";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.5.0.96_cuda11-archive.tar.xz";
        hash = "sha256-VFSm/ZTwCHKMqumtrZk8ToXvNjAuJrzkO+p9RYpee20=";
      }
      {
        version = "8.6.0.163";
        minCudaVersion = "10.2";
        maxCudaVersion = "10.2";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.6.0.163_cuda10-archive.tar.xz";
        hash = "sha256-t4sr/GrFqqdxu2VhaJQk5K1Xm/0lU4chXG8hVL09R9k=";
      }
      {
        version = "8.6.0.163";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz";
        hash = "sha256-u8OW30cpTGV+3AnGAGdNYIyxv8gLgtz0VHBgwhcRFZ4=";
      }
      {
        version = "8.7.0.84";
        minCudaVersion = "10.2";
        maxCudaVersion = "10.2";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.7.0.84_cuda10-archive.tar.xz";
        hash = "sha256-bZhaqc8+GbPV2FQvvbbufd8VnEJgvfkICc2N3/gitRg=";
      }
      {
        version = "8.7.0.84";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.7.0.84_cuda11-archive.tar.xz";
        hash = "sha256-l2xMunIzyXrnQAavq1Fyl2MAukD1slCiH4z3H1nJ920=";
      }
      {
        version = "8.8.1.3";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.8.1.3_cuda11-archive.tar.xz";
        hash = "sha256-r3WEyuDMVSS1kT7wjCm6YVQRPGDrCjegWQqRtRWoqPk=";
      }
      {
        version = "8.8.1.3";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.0";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.8.1.3_cuda12-archive.tar.xz";
        hash = "sha256-edd6dpx+cXWrx7XC7VxJQUjAYYqGQThyLIh/lcYjd3w=";
      }
      {
        version = "8.9.7.29";
        minCudaVersion = "11.0";
        maxCudaVersion = "11.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.9.7.29_cuda11-archive.tar.xz";
        hash = "sha256-o+JQkCjOzaARfOWg9CEGNG6C6G05D0u5R1r8l2x3QC4=";
      }
      {
        version = "8.9.7.29";
        minCudaVersion = "12.0";
        maxCudaVersion = "12.2";
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
        version = "9.3.0.75";
        minCudaVersion = "11.8";
        maxCudaVersion = "11.8";
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-9.3.0.75_cuda11-archive.tar.xz";
        hash = "sha256-Bp2ghM02jzn7gw1MTpMYAwZPtl52b0z33y2ko0aiup8";
      }

    ];
  };
}
