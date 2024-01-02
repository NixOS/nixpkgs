{ lib
, buildPythonPackage
, fetchFromGitHub
, rocmPackages
, ocl-icd
}:
buildPythonPackage {
  pname = "gpuctypes";
  version = "unstable-2023-11-26";

  src = fetchFromGitHub {
    repo = "gpuctypes";
    owner = "tinygrad";
    rev = "3d402bb3bd5536aeb09c55da02277c339b4af089";
    hash = "sha256-bYSjCrVO6Bd/oGCLLp5AcPEe6fFUdnJwxCzRWK54AG8=";
  };

  postPatch = ''
    # patch correct path to opencl
    substituteInPlace gpuctypes/opencl.py --replace "ctypes.util.find_library('OpenCL')" "'${ocl-icd}/lib/libOpenCL.so'"

    # patch correct path to hip
    substituteInPlace gpuctypes/hip.py --replace "/opt/rocm/lib/libamdhip64.so" "${rocmPackages.clr}/lib/libamdhip64.so"
    substituteInPlace gpuctypes/hip.py --replace "/opt/rocm/lib/libhiprtc.so" "${rocmPackages.clr}/lib/libhiprtc.so"
  '';

  pythonImportsCheck = [ "gpuctypes" ];

  meta = with lib; {
    description = "Ctypes wrappers for HIP, CUDA, and OpenCL";
    homepage = "https://github.com/tinygrad/gpuctypes";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan wozeparrot ];
  };

}
