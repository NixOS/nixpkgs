{ lib
, stdenv
, callPackage
, rocm-opencl-runtime
}:

stdenv.mkDerivation rec {
  pname = "rocm-opencl-icd";
  version = rocm-opencl-runtime.version;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/etc/OpenCL/vendors
    echo "${rocm-opencl-runtime}/lib/libamdocl64.so" > $out/etc/OpenCL/vendors/amdocl64.icd
  '';

  passthru.impureTests = { rocm-opencl = callPackage ./test.nix { }; };

  meta = with lib; {
    description = "OpenCL ICD definition for AMD GPUs using the ROCm stack";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
  };
}
