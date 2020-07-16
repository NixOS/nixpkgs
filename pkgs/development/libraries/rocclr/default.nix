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
}:

stdenv.mkDerivation rec {
  pname = "rocclr";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "ROCclr";
    rev = "roc-${version}";
    sha256 = "0j70lxpwrdrb1v4lbcyzk7kilw62ip4py9fj149d8k3x5x6wkji1";
  };

  nativeBuildInputs = [ cmake rocm-cmake ];

  buildInputs = [ clang rocm-comgr rocm-runtime rocm-thunk clang ];

  propagatedBuildInputs = [ libelf libglvnd libX11 ];

  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'set(ROCCLR_EXPORTS_FILE "''${CMAKE_CURRENT_BINARY_DIR}/amdrocclr_staticTargets.cmake")' \
        'set(ROCCLR_EXPORTS_FILE "''${CMAKE_INSTALL_LIBDIR}/cmake/amdrocclr_staticTargets.cmake")' \
      --replace 'set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ''${CMAKE_CURRENT_BINARY_DIR}/lib)' \
        'set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ''${CMAKE_INSTALL_LIBDIR})'
    substituteInPlace device/comgrctx.cpp \
      --replace "libamd_comgr.so" "${rocm-comgr}/lib/libamd_comgr.so"
  '';

  cmakeFlags = [
    "-DOPENCL_DIR=${rocm-opencl-runtime.src}"
  ];

  preFixup = ''
    mv $out/include/include/* $out/include
    ln -s $out/include/compiler/lib/include/* $out/include/include
    ln -s $out/include/compiler/lib/include/* $out/include
    sed "s|^\([[:space:]]*IMPORTED_LOCATION_RELEASE \).*|\1 \"$out/lib/libamdrocclr_static.a\"|" -i $out/lib/cmake/amdrocclr_staticTargets.cmake
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
