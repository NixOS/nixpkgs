{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
, pytestCheckHook
, setuptools
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, torch
, einops
, lion-pytorch
, scipy
, symlinkJoin
}:

let
  pname = "bitsandbytes";
<<<<<<< HEAD
  version = "0.41.0";
=======
  version = "0.38.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    paths = with cudaPackages; [
      cuda_cudart # cuda_runtime.h cuda_runtime_api.h
      cuda_nvcc
    ] ++ cuda-common-redist;
  };

  cuda-redist = symlinkJoin {
    name = "cuda-redist-${cudaVersion}";
    paths = cuda-common-redist;
  };

in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TimDettmers";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-e6SK2ylITookO6bhpfdRp/V4y2S9rk6Lo1PD3xXrcmM=";
=======
    hash = "sha256-gGlbzTDvZNo4MhcYzLvWuB2ec7q+Qt5/LtTbJ0Rc+Kk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace Makefile --replace "/usr/bin/g++" "g++" --replace "lib64" "lib"
    substituteInPlace bitsandbytes/cuda_setup/main.py  \
<<<<<<< HEAD
      --replace "binary_path = package_dir / self.binary_name"  \
                "binary_path = Path('$out/${python.sitePackages}/${pname}')/self.binary_name"
=======
      --replace "binary_path = package_dir / binary_name"  \
                "binary_path = Path('$out/${python.sitePackages}/${pname}')/binary_name"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '' + lib.optionalString torch.cudaSupport ''
    substituteInPlace bitsandbytes/cuda_setup/main.py  \
      --replace "/usr/local/cuda/lib64" "${cuda-native-redist}/lib"
  '';

  CUDA_HOME = "${cuda-native-redist}";

  preBuild = if torch.cudaSupport then
    with torch.cudaPackages;
    let cudaVersion = lib.concatStrings (lib.splitVersion torch.cudaPackages.cudaMajorMinorVersion); in
    ''make CUDA_VERSION=${cudaVersion} cuda${cudaMajorVersion}x''
  else
    ''make CUDA_VERSION=CPU cpuonly'';

<<<<<<< HEAD
  nativeBuildInputs = [ setuptools wheel ] ++ lib.optionals torch.cudaSupport [ cuda-native-redist ];
  buildInputs = lib.optionals torch.cudaSupport [ cuda-redist ];

  propagatedBuildInputs = [
    scipy
=======
  nativeBuildInputs = [ setuptools ] ++ lib.optionals torch.cudaSupport [ cuda-native-redist ];
  buildInputs = lib.optionals torch.cudaSupport [ cuda-redist ];

  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    torch
  ];

  doCheck = false;  # tests require CUDA and also GPU access
<<<<<<< HEAD
  nativeCheckInputs = [ pytestCheckHook einops lion-pytorch ];
=======
  nativeCheckInputs = [ pytestCheckHook einops lion-pytorch scipy ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "bitsandbytes"
  ];

  meta = with lib; {
    homepage = "https://github.com/TimDettmers/bitsandbytes";
    description = "8-bit CUDA functions for PyTorch";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
