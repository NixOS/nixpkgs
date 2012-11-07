{stdenv, stdenv_32bit, fetchurl, unzip, shebangfix, zlib, ncurses}:

stdenv.mkDerivation {
  name = "android-platform-tools-r15_rc7";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = https://dl-ssl.google.com/android/repository/platform-tools_r15_rc7-linux.zip;
      sha1 = "444e12ba413341282cd810d2e4bdb49975c95758";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = https://dl-ssl.google.com/android/repository/platform-tools_r15_rc7-macosx.zip;
      sha1 = "974eac4afbe404278fcda8f8cd39b55c82be012d";
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
    
    shebangfix dx
  '';
  
  buildInputs = [ unzip shebangfix ];
}
