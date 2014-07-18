{stdenv, stdenv_32bit, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "android-platform-tools-r20";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = https://dl-ssl.google.com/android/repository/platform-tools_r20-linux.zip;
      sha256 = "e596fb0950c1bdea3a47ee115b37f09a6fad128d70303e99cb70f3de65803033";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = https://dl-ssl.google.com/android/repository/platform-tools_r20-macosx.zip;
      sha256 = "e57fd892cb8cda86a7fc506e14b462d4c244da31b399c0e663e095e9fd433b80";
    }
    else throw "System ${stdenv.system} not supported!";
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
    cd platform-tools
    
    ${stdenv.lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
      ''
        for i in adb fastboot
        do
            patchelf --set-interpreter ${stdenv_32bit.gcc.libc}/lib/ld-linux.so.2 $i
            patchelf --set-rpath ${stdenv_32bit.gcc.gcc}/lib $i
        done
    ''}
  '';
  
  buildInputs = [ unzip ];
}
