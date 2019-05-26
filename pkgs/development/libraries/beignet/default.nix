{ stdenv
, fetchurl
, cmake
, pkgconfig
, clang-unwrapped
, llvm
, libdrm
, libX11
, libpthreadstubs
, libXdmcp
, libXdamage
, libXext
, python3
, ocl-icd
, libGL
, makeWrapper
, beignet
}:

stdenv.mkDerivation rec {
  name = "beignet-${version}";
  version = "1.3.2";

  src = fetchurl {
    url = "https://01.org/sites/default/files/${name}-source.tar.gz"; 
    sha256 = "0hqb04jhjjslnmi3fnpzphanz84zywwkyw2sjr1k5qlx2jxfsmf5";
  };

  patches = [ ./clang_llvm.patch ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs src/git_sha1.sh
  '';

  cmakeFlags = [ "-DCLANG_LIBRARY_DIR=${clang-unwrapped}/lib" ];

  buildInputs = [
    llvm
    clang-unwrapped
    libX11
    libXext
    libpthreadstubs
    libdrm
    libXdmcp
    libXdamage
    ocl-icd
    libGL
  ];

  nativeBuildInputs = [
    cmake
    pkgconfig
    python3
  ];

  passthru.utests = stdenv.mkDerivation rec {
    name = "beignet-utests-${version}";
    inherit version src;

    preConfigure = ''
      cd utests
    '';

    enableParallelBuilding = true;

    nativeBuildInputs = [
      cmake
      python3
      pkgconfig
      makeWrapper
    ];

    buildInputs = [
      ocl-icd
    ];

    installPhase = ''
      wrapBin() {
        install -Dm755 "$1" "$out/bin/$(basename "$1")"
        wrapProgram "$out/bin/$(basename "$1")" \
          --set OCL_BITCODE_LIB_PATH ${beignet}/lib/beignet/beignet.bc \
          --set OCL_HEADER_FILE_DIR "${beignet}/lib/beignet/include" \
          --set OCL_PCH_PATH "${beignet}/lib/beignet/beignet.pch" \
          --set OCL_GBE_PATH "${beignet}/lib/beignet/libgbe.so" \
          --set OCL_INTERP_PATH "${beignet}/lib/beignet/libgbeinterp.so" \
          --set OCL_KERNEL_PATH "$out/lib/beignet/kernels" \
          --set OCL_IGNORE_SELF_TEST 1
      }

      install -Dm755 libutests.so $out/lib/libutests.so
      wrapBin utest_run
      wrapBin flat_address_space
      mkdir $out/lib/beignet
      cp -r ../../kernels $out/lib/beignet
    '';
  };

  meta = with stdenv.lib; {
    homepage = https://cgit.freedesktop.org/beignet/;
    description = "OpenCL Library for Intel Ivy Bridge and newer GPUs";
    longDescription = ''
      The package provides an open source implementation of the OpenCL specification for Intel GPUs. 
      It supports the Intel OpenCL runtime library and compiler. 
    '';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ artuuge zimbatm ];
    platforms = platforms.linux;
    # Requires libdrm_intel
    badPlatforms = [ "aarch64-linux" ];
  };
}
