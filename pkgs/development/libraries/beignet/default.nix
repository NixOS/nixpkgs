{ stdenv
, fetchurl
, cmake
, pkgconfig
, clang-unwrapped
, llvm
, libdrm
, libX11
, libXfixes
, libpthreadstubs
, libXdmcp
, libXdamage
, libXxf86vm
, python
, gl
, ocl-icd
}: 

stdenv.mkDerivation rec {
  name = "beignet-${version}";
  version = "1.1.2"; 

  src = fetchurl {
    url = "https://01.org/sites/default/files/${name}-source.tar.gz"; 
    sha256 = "6a8d875afbb5e3c4fc57da1ea80f79abadd9136bfd87ab1f83c02784659f1d96"; 
  };  

  patches = [ ./clang_llvm.patch ]; 

  postPatch = ''
    patchShebangs src/git_sha1.sh; 

    for f in $(find utests -type f)
    do
      sed -e "s@isnan(@std::isnan(@g" -i $f
      sed -e "s@_std::isnan@_isnan@g" -i $f

      sed -e "s@isinf(@std::isinf(@g" -i $f
      sed -e "s@_std::isinf@_isinf@g" -i $f
    done
  ''; 

  configurePhase = ''
    cmake . -DCMAKE_INSTALL_PREFIX=$out \
            -DCLANG_LIBRARY_DIR="${clang-unwrapped}/lib" \
            -DLLVM_INSTALL_DIR="${llvm}/bin" \
            -DCLANG_INSTALL_DIR="${clang-unwrapped}/bin"
  '';

  postInstall = ''
    mkdir -p $out/utests/kernels
    mkdir -p $out/utests/lib

    cp -r kernels $out/utests
    cp src/libcl.so $out/utests/lib

    cat > $out/utests/setenv.sh << EOF
#!/bin/sh
export OCL_BITCODE_LIB_PATH=$out/lib/beignet/beignet.bc
export OCL_HEADER_FILE_DIR=$out/lib/beignet/include
export OCL_PCH_PATH=$out/lib/beignet/beignet.pch
export OCL_GBE_PATH=$out/lib/beignet/libgbe.so
export OCL_INTERP_PATH=$out/lib/beignet/libgbeinterp.so
export OCL_KERNEL_PATH=$out/utests/kernels
export OCL_IGNORE_SELF_TEST=1
EOF

    function fixRunPath {
      p0=$(patchelf --print-rpath $1)
      p1=$(echo $p0 | sed -e "s@$(pwd)/src@$out/utests/lib@g" -)
      p2=$(echo $p1 | sed -e "s@$(pwd)/utests@$out/utests@g" -)
      patchelf --set-rpath $p2 $1 
    }
    
    fixRunPath utests/utest_run
    fixRunPath utests/libutests.so

    cp utests/utest_run $out/utests
    cp utests/libutests.so $out/utests

    mkdir -p $out/bin
    ln -s $out/utests/setenv.sh $out/bin/beignet_setenv.sh
    ln -s $out/utests/utest_run $out/bin/beignet_utest_run
  ''; 

  # To run the unit tests, the user must be in "video" group. 
  # The nix builders are members of only "nixbld" group, so 
  # they are able to compile the tests, but not to run them. 
  # To verify the installation, add yourself to "video" group, 
  # switch to a working directory which has both read and write 
  # permissions, run: nix-shell -p pkgs.beignet, and execute:
  # . beignet_setenv.sh && beignet_utest_run
  doCheck = false; 

  buildInputs = [ 
    llvm 
    clang-unwrapped
    cmake 
    libX11 
    pkgconfig 
    libdrm 
    gl 
    libXfixes 
    libpthreadstubs
    libXdmcp
    libXdamage
    libXxf86vm
    python
    ocl-icd
  ];

  meta = with stdenv.lib; {
    homepage = https://cgit.freedesktop.org/beignet/;
    description = "OpenCL Library for Intel Ivy Bridge and newer GPUs";
    longDescription = ''
      The package provides an open source implementation of the OpenCL specification for Intel GPUs. 
      It supports the Intel OpenCL runtime library and compiler. 
    '';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.linux;
  }; 
}
