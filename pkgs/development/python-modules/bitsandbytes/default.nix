{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
  setuptools,
  wheel,
  torch,
  scipy,
  symlinkJoin,
}:

let
  pname = "bitsandbytes";
  version = "0.42.0";

  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
  inherit (cudaPackages) backendStdenv cudaVersion;

  # NOTE: torchvision doesn't use cudnn; torch does!
  #   For this reason it is not included.
  cuda-common-redist = with cudaPackages; [
    cuda_cccl # <thrust/*>
    libcublas # cublas_v2.h
    libcurand
    libcusolver # cusolverDn.h
    libcusparse # cusparse.h
  ];

  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaVersion}";
    paths =
      with cudaPackages;
      [
        cuda_cudart # cuda_runtime.h cuda_runtime_api.h
        cuda_nvcc
      ]
      ++ cuda-common-redist;
  };

  cuda-redist = symlinkJoin {
    name = "cuda-redist-${cudaVersion}";
    paths = cuda-common-redist;
  };
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TimDettmers";
    repo = "bitsandbytes";
    rev = "refs/tags/${version}";
    hash = "sha256-PZxsFJ6WpfeQqRQrRRBZfZfNY6/TfJFLBeknX24OXcU=";
  };

  postPatch =
    ''
      substituteInPlace Makefile --replace "/usr/bin/g++" "g++" --replace "lib64" "lib"
      substituteInPlace bitsandbytes/cuda_setup/main.py  \
        --replace "binary_path = package_dir / self.binary_name"  \
                  "binary_path = Path('$out/${python.sitePackages}/${pname}')/self.binary_name"
    ''
    + lib.optionalString torch.cudaSupport ''
      substituteInPlace bitsandbytes/cuda_setup/main.py  \
        --replace "/usr/local/cuda/lib64" "${cuda-native-redist}/lib"
    '';

  CUDA_HOME = "${cuda-native-redist}";

  preBuild =
    if torch.cudaSupport then
      with torch.cudaPackages;
      let
        cudaVersion = lib.concatStrings (lib.splitVersion torch.cudaPackages.cudaMajorMinorVersion);
      in
      ''make CUDA_VERSION=${cudaVersion} cuda${cudaMajorVersion}x''
    else
      ''make CUDA_VERSION=CPU cpuonly'';

  nativeBuildInputs = [
    setuptools
    wheel
  ] ++ lib.optionals torch.cudaSupport [ cuda-native-redist ];

  buildInputs = lib.optionals torch.cudaSupport [ cuda-redist ];

  propagatedBuildInputs = [
    scipy
    torch
  ];

  doCheck = false; # tests require CUDA and also GPU access

  pythonImportsCheck = [ "bitsandbytes" ];

  meta = with lib; {
    description = "8-bit CUDA functions for PyTorch";
    homepage = "https://github.com/TimDettmers/bitsandbytes";
    changelog = "https://github.com/TimDettmers/bitsandbytes/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
