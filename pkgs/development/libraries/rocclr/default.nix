{ stdenv
, fetchFromGitHub
, cmake
, rocm-cmake
, clang
, rocm-comgr
, rocm-opencl-runtime
, rocm-runtime
, rocm-thunk
, libelf
, libglvnd
, libX11
, numactl
}:

stdenv.mkDerivation rec {
  pname = "rocclr";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "ROCclr";
    rev = "rocm-${version}";
    sha256 = "05vh70qh6jb7038b1rcmz24bg4an0nw98bv2vn3jcyygj4dr3fmf";
  };

  nativeBuildInputs = [ cmake rocm-cmake ];

  buildInputs = [ clang rocm-comgr rocm-runtime rocm-thunk ];

  propagatedBuildInputs = [ libelf libglvnd libX11 numactl ];

  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'set(ROCCLR_EXPORTS_FILE "''${CMAKE_CURRENT_BINARY_DIR}/amdrocclr_staticTargets.cmake")' \
        'set(ROCCLR_EXPORTS_FILE "''${CMAKE_INSTALL_LIBDIR}/cmake/amdrocclr_staticTargets.cmake")' \
      --replace 'set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ''${CMAKE_CURRENT_BINARY_DIR}/lib)' \
        'set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ''${CMAKE_INSTALL_LIBDIR})' \
      --replace 'find_library( OpenCL REQUIRED' 'find_library( OpenCL'
    substituteInPlace device/comgrctx.cpp \
      --replace "libamd_comgr.so" "${rocm-comgr}/lib/libamd_comgr.so"
  '';

  cmakeFlags = [
    "-DOPENCL_DIR=${rocm-opencl-runtime.src}"
  ];

  preFixup = ''
    ln -s $out/include/compiler/lib/include/* $out/include
    substituteInPlace $out/lib/cmake/rocclr/ROCclrConfig.cmake \
      --replace "/build/source/build" "$out"
  '';

  meta = with stdenv.lib; {
    description = "Radeon Open Compute common language runtime";
    homepage = "https://github.com/ROCm-Developer-Tools/ROCclr";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    # rocclr seems to have some AArch64 ifdefs, but does not seem
    # to be supported yet by the build infrastructure. Recheck in
    # the future.
    platforms = [ "x86_64-linux" ];
  };
}
