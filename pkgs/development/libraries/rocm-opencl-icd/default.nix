{ stdenv, rocm-opencl-runtime }:

stdenv.mkDerivation rec {
  pname = "rocm-opencl-icd";
  version = "3.5.0";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/etc/OpenCL/vendors
    echo "${rocm-opencl-runtime}/lib/libamdocl64.so" > $out/etc/OpenCL/vendors/amdocl64.icd
  '';

  meta = with stdenv.lib; {
    description = "OpenCL ICD definition for AMD GPUs using the ROCm stack";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    platforms = platforms.linux;
  };
}
