{stdenv, stdenv_32bit, fetchurl, unzip, zlib_32bit, ncurses_32bit}:

stdenv.mkDerivation rec {
  version = "23.0.1";
  name = "android-build-tools-r${version}";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = "https://dl.google.com/android/repository/build-tools_r${version}-linux.zip";
      sha1 = "b6ba7c399d5fa487d95289d8832e4ad943aed556";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = "https://dl.google.com/android/repository/build-tools_r${version}-macosx.zip";
      sha1 = "d96ec1522721e9a179ae2c591c99f75d31d39718";
    }
    else throw "System ${stdenv.system} not supported!";

  buildCommand = ''
    mkdir -p $out/build-tools
    cd $out/build-tools
    unzip $src
    mv android-* ${version}
    
    ${stdenv.lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
      ''
        cd ${version}
        
        # Patch the interpreter
        for i in aapt aidl bcc_compat dexdump llvm-rs-cc
        do
            patchelf --set-interpreter ${stdenv_32bit.cc.libc.out}/lib/ld-linux.so.2 $i
        done
        
        # These binaries need to find libstdc++ and libgcc_s
        for i in aidl lib/libLLVM.so
        do
            patchelf --set-rpath ${stdenv_32bit.cc.cc}/lib $i
        done
        
        # These binaries need to find libstdc++, libgcc_s and libraries in the current folder
        for i in lib/libbcc.so lib/libbcinfo.so lib/libclang.so aidl
        do
            patchelf --set-rpath ${stdenv_32bit.cc.cc}/lib:`pwd`/lib $i
        done
        
        # Create link to make libtinfo.so.5 work
        ln -s ${ncurses_32bit}/lib/libncurses.so.5 `pwd`/lib/libtinfo.so.5
        
        # These binaries need to find libstdc++, libgcc_s, ncurses, and libraries in the current folder
        for i in bcc_compat llvm-rs-cc
        do
            patchelf --set-rpath ${stdenv_32bit.cc.cc}/lib:${ncurses_32bit}/lib:`pwd`/lib $i
        done

        # These binaries also need zlib in addition to libstdc++
        for i in arm-linux-androideabi-ld i686-linux-android-ld mipsel-linux-android-ld split-select zipalign
        do
            patchelf --set-interpreter ${stdenv_32bit.cc.libc.out}/lib/ld-linux.so.2 $i
            patchelf --set-rpath ${stdenv_32bit.cc.cc}/lib:${zlib_32bit}/lib:`pwd`/lib $i
        done
        
        # These binaries need to find libstdc++, libgcc_s, and zlib
        for i in aapt dexdump
        do
            patchelf --set-rpath ${stdenv_32bit.cc.cc}/lib:${zlib_32bit}/lib:`pwd`/lib $i
        done
      ''}
      
      patchShebangs .
  '';
  
  buildInputs = [ unzip ];
}
