{stdenv, stdenv_32bit, fetchurl, unzip, zlib_32bit}:

stdenv.mkDerivation {
  name = "android-build-tools-r18.1.0";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = https://dl-ssl.google.com/android/repository/build-tools_r18.1-linux.zip;
      sha1 = "f314a0599e51397f0886fe888b50dd98f2f050d8";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = https://dl-ssl.google.com/android/repository/build-tools_r18.1-macosx.zip;
      sha1 = "16ddb299b8b43063e5bb3387ec17147c5053dfd8";
    }
    else throw "System ${stdenv.system} not supported!";
  
  buildCommand = ''
    mkdir -p $out/build-tools
    cd $out/build-tools
    unzip $src
    
    ${stdenv.lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
      ''
        cd android-*
        
        # Patch the interpreter
        for i in aapt aidl dexdump llvm-rs-cc
        do
            patchelf --set-interpreter ${stdenv_32bit.gcc.libc}/lib/ld-linux.so.2 $i
        done
        
        # These binaries need to find libstdc++ and libgcc_s
        for i in aidl libLLVM.so
        do
            patchelf --set-rpath ${stdenv_32bit.gcc.gcc}/lib $i
        done
        
        # These binaries need to find libstdc++, libgcc_s and libraries in the current folder
        for i in libbcc.so libbcinfo.so libclang.so llvm-rs-cc
        do
            patchelf --set-rpath ${stdenv_32bit.gcc.gcc}/lib:`pwd` $i
        done
        
        # These binaries need to find libstdc++, libgcc_s, and zlib
        for i in aapt dexdump
        do
            patchelf --set-rpath ${stdenv_32bit.gcc.gcc}/lib:${zlib_32bit}/lib $i
        done
      ''}
      
      patchShebangs .
  '';
  
  buildInputs = [ unzip ];
}
