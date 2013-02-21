{stdenv, stdenv_32bit, fetchurl, unzip, zlib, ncurses}:

stdenv.mkDerivation {
  name = "android-platform-tools-r16";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = https://dl-ssl.google.com/android/repository/platform-tools_r16-linux.zip;
      sha1 = "84d563ae5e324f223f335f11bf511bf6207c05fb";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = https://dl-ssl.google.com/android/repository/platform-tools_r16-macosx.zip;
      sha1 = "fbb0f8d2786a83b8c3eb6df402e706e136db8fed";
    }
    else throw "System ${stdenv.system} not supported!";
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
    cd platform-tools
    
    ${stdenv.lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
      ''
        for i in aapt adb aidl dexdump fastboot llvm-rs-cc
        do
            patchelf --set-interpreter ${stdenv_32bit.gcc.libc}/lib/ld-linux.so.2 $i
        done
    
        patchelf --set-rpath ${zlib}/lib:${stdenv_32bit.gcc.gcc}/lib aapt
        patchelf --set-rpath ${ncurses}/lib:${stdenv_32bit.gcc.gcc}/lib adb
        patchelf --set-rpath ${stdenv_32bit.gcc.gcc}/lib aidl
        patchelf --set-rpath ${stdenv_32bit.gcc.gcc}/lib fastboot
        patchelf --set-rpath ${zlib}/lib:${stdenv_32bit.gcc.gcc}/lib dexdump
        patchelf --set-rpath ${stdenv_32bit.gcc.gcc}/lib llvm-rs-cc
    ''}
    
    patchShebangs .
  '';
  
  buildInputs = [ unzip ];
}
